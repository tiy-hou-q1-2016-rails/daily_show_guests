class Guest
  attr_accessor :name, :year, :occupation, :show_date, :occupation_group, :name_starter

  def name_starter
    if self.name.chars.first == '('
      self.name_starter = ' '
    else
      self.name_starter = self.name.chars.first
    end
  end
end
