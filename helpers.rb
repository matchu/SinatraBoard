helpers do
  def stats_for(pane)
    begin
      stats = pane.stats
    rescue Resource::ResourceError => e
      haml :pane_error, :locals => {:error => e}
    else
      haml :pane_stats, :locals => {:stats => stats}
    end
  end
end

