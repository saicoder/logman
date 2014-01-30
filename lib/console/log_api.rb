module Logman
  class LogAPI < ConsoleBase
    
    get '/api/buckets/:id/logs',:auth=>:user do
      bucket = Bucket.find(params[:id])
      
      if bucket.nil?
        status 404
      else
        page = params[:page] || 1
         
        pagination={
          :order    => :created_at.desc,
          :per_page => params[:per_page] || 10, 
          :page     => page
        }
        
       
        data = bucket.logs.paginate(pagination)
        
        res ={
          :page => page,
          :items => data,
          :total_items => bucket.logs.count,
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