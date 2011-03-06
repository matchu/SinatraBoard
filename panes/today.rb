require 'date'
class Today < Pane
  FORMAT = "%m/%d"

  title "Today"
  stat { Date.today.strftime(FORMAT) }
end

