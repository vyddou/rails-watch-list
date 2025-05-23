module ApplicationHelper
  def rating_color(rating)
  case rating
  when 8..10 then 'bg-success'
  when 5...8 then 'bg-warning'
  else 'bg-danger'
  end
end
end
