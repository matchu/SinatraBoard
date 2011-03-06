require 'date'
class Today < Pane
  title "Today"
  stat do
    date = Date.today
    "#{date.month}/#{date.day}"
  end
end

