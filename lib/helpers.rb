helpers do
  def partial(page, options={})
    erb "_#{page}".to_sym, options.merge!(:layout => false)
  end
end