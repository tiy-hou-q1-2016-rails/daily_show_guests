class GuestsController < ApplicationController
  def index
    @guests = fetch_guests(' ')

    @bar_chart_column = []
    @bar_chart_column = @guests.map {|guest| guest.occupation_group.titleize}.uniq.sort


    @bar_chart_rows = []
    (1999..2015).to_a.each do |year|
      current_row = []
      current_row << year.to_s
      @bar_chart_column.each do |occupation|
        intermediate = @guests.select{|guest| guest.occupation_group.include? occupation.downcase}
        intermediate = intermediate.select{|guest| guest.year == year.to_s}.count
        current_row << intermediate
      end
      @bar_chart_rows << current_row
    end
    @bar_chart_column.unshift('Year')
    @bar_chart_data = @bar_chart_rows.unshift(@bar_chart_column)
    puts @bar_chart_data.inspect

  end

  def list
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)
    @guests_all = @guests

    @guest_count = @guests.count
    @guests = Kaminari.paginate_array(@guests).page(params[:page]).per(100)

  end

  def year
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)
    @guests_all = @guests

    @guests = @guests.select{|guest| guest.year == params[:year]}
    if @guests.nil?
      render text: "No such guest", status: 404
    else
      @guest_count = @guests.count
      @guests = Kaminari.paginate_array(@guests).page(params[:page]).per(100)
    end

    render :list
  end

  def occupation
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)
    @guests_all = @guests

    @guests = @guests.select{|guest| guest.occupation_group == params[:occupation_group]}
    if @guests.nil?
      render text: "No such guest", status: 404
    else
      @guest_count = @guests.count
      @guests = Kaminari.paginate_array(@guests).page(params[:page]).per(100)
    end

    render :list
  end

  def name
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)
    @guests_all = @guests

    @guests = @guests.select{|guest| guest.name == params[:name]}
    if @guests.nil?
      render text: "No such guest", status: 404
    else
      @guest_count = @guests.count
      @guests = Kaminari.paginate_array(@guests).page(params[:page]).per(100)
    end
    render :list
  end

  def name_starter
    if params[:search_text].present?
      sql_query = "SELECT * FROM guests WHERE name LIKE '%#{params[:search_text]}%'
                  OR occupation LIKE '%#{params[:search_text]}%'
                  OR occupation_group LIKE '%#{params[:search_text]}%'"
    else
      sql_query = ' '
    end
    @guests = fetch_guests(sql_query)
    @guests_all = @guests

    @guests = @guests.select{|guest| guest.name_starter == params[:name_starter]}
    if @guests.nil?
      render text: "No such guest", status: 404
    else
      @guest_count = @guests.count
      @guests = Kaminari.paginate_array(@guests).page(params[:page]).per(100)
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
      guest.occupation = hash["occupation"]
      guest.show_date = hash["show_date"]
      guest.occupation_group = hash["occupation_group"]
      guest.name = hash["name"].downcase
      guest
    end
    # puts guests.inspect
    guests
  end

  def titleize
    split(/(\W)/).map(&:capitalize).join
  end

end
