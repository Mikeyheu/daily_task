require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/daily_task.db")  

class Task  
  include DataMapper::Resource  
  property :id, Serial  
  property :position, Integer, default: 0
  property :content, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
end  

DataMapper.finalize.auto_upgrade! # runs migration after adding new property

get '/' do 
	@tasks = Task.all order: :position.asc
	erb :index
end

post '/' do # create
  # Increment all existing task positions by 1
  tasks = Task.all
  tasks.each do |task|
    task.position = task.position + 1
    task.save
  end

  #create new task with default position of 0
	t = Task.new
	t.content = params[:content]
	t.save
  
	redirect '/'
end

post '/sort' do
  params[:task].each_with_index do |task, index|
    t = Task.get(task.to_i)
    t.position = index
    t.save # might be expensive 
  end
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