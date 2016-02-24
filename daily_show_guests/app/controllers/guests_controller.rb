class GuestsController < ApplicationController
  def index
    @guests = fetch_guests
  end

  def list
    @guests = fetch_guests
    if params[:search_text].present?
       @guests = @guests.select{|guest| guest.name.downcase.include? params[:search_text].downcase}
      #  @filtered_guests = []
      #  @filtered_guests << @guests.select{|guest| guest.name.downcase.include? params[:search_text].downcase}
      #  @filtered_guests << @guests.select{|guest| guest.year.downcase.include? params[:search_text].downcase}
      #  @filtered_guests << @guests.select{|guest| guest.show_date.downcase.include? params[:search_text].downcase}
      #  @filtered_guests << @guests.select{|guest| guest.occupation.include? params[:search_text].downcase}
      #  @filtered_guests << @guests.select{|guest| guest.occupation_group.include? params[:search_text].downcase}
      #  @guests = @filtered_guests
    end
    puts @guests.inspect
    # puts @filtered_guests.inspect
  end

  def year
    @guests = fetch_guests.select{|guest| guest.year == params[:year]}
    if @guests.nil?
      render text: "Product not found.", status: 404
    end

    # need to add
      # if params[:search_text].present?
      #    @guests = @guests.select{|guest| guest.name.downcase.include? params[:search_text].downcase}
      #   #  blah
      # end

    render :list
  end

  def occupation
    @guests = fetch_guests.select{|guest| guest.occupation_group == params[:occupation_group]}
    if @guests.nil?
      render text: "Product not found.", status: 404
    end

    # need to add
      # if params[:search_text].present?
      #    @guests = @guests.select{|guest| guest.name.downcase.include? params[:search_text].downcase}
      #   #  blah
      # end

    render :list
  end

  def name
    @guests = fetch_guests.select{|guest| guest.name == params[:name]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end
    render :list
  end

  def name_starter
    @guests = fetch_guests.select{|guest| guest.name_starter == params[:name_starter]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end
    render :list
  end

  def fetch_guests
    sql_query = "select * from guests order by year asc"
    guests = ActiveRecord::Base.connection.execute(sql_query)
    # turn the 'dumb' hash data into an object

    guests = guests.map do |hash|
      guest = Guest.new
      guest.year = hash["year"]
      guest.occupation = hash["occupation"].capitalize
      guest.show_date = hash["show_date"]
      guest.occupation_group = hash["occupation_group"].capitalize
      guest.name = hash["name"]
      guest
    end
    # puts guests.inspect
    guests
  end
end
