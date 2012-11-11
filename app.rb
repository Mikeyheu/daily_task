require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/daily_task.db")  

class Task  
  include DataMapper::Resource  
  property :id, Serial  
  property :content, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
end  

DataMapper.finalize.auto_upgrade!

get '/' do 
	@tasks = Task.all order: :id.desc
	# @title = 'Home'
	erb :index
end

post '/' do 
	t = Task.new
	t.content = params[:content]
	t.save
	redirect '/'
end

get '/:id/complete' do  
  t = Task.get params[:id]  
  t.complete = t.complete ? 0 : 1 # flip it   
  t.save  
  redirect '/'  
end 

delete '/:id' do  
  t = Task.get params[:id]  
  t.destroy  
  redirect '/'  
end  