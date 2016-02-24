class GuestsController < ApplicationController
  def index
    @guests = fetch_guests(' ')
  end

  def list
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'
                  ORDER BY year asc"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)

  end

  def year
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'
                  ORDER BY year asc"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)

    @guests = @guests.select{|guest| guest.year == params[:year]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end

    render :list
  end

  def occupation
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'
                  ORDER BY year asc"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)

    @guests = @guests.select{|guest| guest.occupation_group == params[:occupation_group]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end

    render :list
  end

  def name
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'
                  ORDER BY year asc"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)

    @guests = @guests.select{|guest| guest.name == params[:name]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end
    render :list
  end

  def name_starter
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'
                  ORDER BY year asc"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)

    @guests = @guests.select{|guest| guest.name_starter == params[:name_starter]}
    if @guests.nil?
      render text: "No such guest", status: 404
    end
    render :list
  end

  def fetch_guests(sql_query)
    if sql_query == ' '
      sql_query = "select * from guests order by year asc"
    end
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
