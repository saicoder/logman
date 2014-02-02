class Logman
  class LogAPI < ConsoleBase
    
    get '/api/buckets/:id/logs',:auth=>:user do
      bucket = Bucket.find(params[:id])
      
      if bucket.nil?
        status 404
      else
        page = params[:page] || 1
        per_page = params[:per_page] || 10 
        
        page = page.to_i
        per_page = per_page.to_i
       
        data = bucket.logs.order_by(:_id.desc)
        
        query = QueryBuilder.new(data)
        data = query.execute(params[:query])
        
        
        #paginate 
        total_count = data.count      
        data = data.skip((page-1)*per_page).take(per_page)
        
        res ={
          :page => page,
          :items => data,
          :total_items => total_count,
        }
        
        json res
        
      end
    end
    
    get '/app/dashboard-view',:auth=>:user do
      graph_data = (7.days.ago.to_date..Date.today).map {|t| {date: t, count: Log.count_on_date(t)} }
      erb :dashboard, :locals=>{:graph_data=> graph_data}
    end
    
  end
end