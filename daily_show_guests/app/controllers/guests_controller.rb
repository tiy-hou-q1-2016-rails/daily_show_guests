class GuestsController < ApplicationController
  def index
    @guests = fetch_guests
  end

  def list
    @guests = fetch_guests
  end

  def fetch_guests
    sql_query = "select * from guests order by name asc"
    guests = ActiveRecord::Base.connection.execute(sql_query)
    # turn the 'dumb' hash data into an object

    guests = guests.map do |hash|
      guest = Guest.new
      guest.id = hash["id"]
      guest.name = hash["name"]
      guest.year = hash["year"]
      guest.occupation = hash["occupation"]
      guest.show_date = hash["show_date"]
      guest.occupation_group = hash["occupation_group"]
      guest
    end
    guests
  end
end
