
# to run this, run `rake db:create`
# to run this, and  `rake db:seed`

sql_query = <<-SQLQUERY
DROP TABLE IF EXISTS guests;
create table guests(
       id bigserial primary key,
       year varchar(255) NOT NULL,
       occupation varchar(255) NOT NULL,
       show_date varchar(255) NOT NULL,
       occupation_group varchar(255) NOT NULL,
       name varchar(255) NOT NULL
);
COPY guests ("year","occupation","show_date","occupation_group","name") FROM '#{Rails.root}/daily_show_guests.csv' DELIMITER ',' CSV HEADER;

DELETE FROM guests
WHERE id IN (SELECT id
              FROM (SELECT id,
                             ROW_NUMBER() OVER (partition BY year, occupation, show_date, occupation_group, name ORDER BY id) AS rnum
                     FROM guests) t
              WHERE t.rnum > 1);

SQLQUERY

# ------ starts ruby code again


ActiveRecord::Base.connection.execute(sql_query)

sql_query = "select * from guests"

records = ActiveRecord::Base.connection.execute(sql_query)

puts "Created #{records.count} records"
