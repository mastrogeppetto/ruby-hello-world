require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

user = {
'augusto' => {password:'qwerty',uid:'landlord:00001'},
'algo' => {password:'123',uid:'admin:0'},
'giampaolo' => {password:'bonaldi',uid:'landlord:00002'},
'marco' => {password:'sensi',uid:'landlord:00003'}
}

landlord = {
  'landlord:00001' => { 
    exitname: 'augusto',
    surname:  'ciuffoletti'},
  'landlord:00002' => { 
    name: 'giampaolo',
    surname:  'bonaldi'},
  'landlord:00003' => { 
    name: 'marco',
    surname:  'sensi'}
}

availability = {
  "availability:00001" => { 
    landlord: 'landlord:00001',
    lat:'43.782415',
    long: '11.244055',
    startdate: '1481760000',
    enddate: '1482537600'
  },
  "availability:00003" => { 
    landlord: 'landlord:00001',
    lat:'43.708067',
    long: '10.405961',
    startdate: '1481760000',
    enddate: '1482537600'
  }
}

property = {
  "property:00001" => { 
    landlord: 'landlord:00001',
    lat:'43.782415',
    long: '11.244055',
    type: 'apartment'
  },
  "property:00002" => { 
    landlord: 'landlord:00002',
    lat:'43.708067',
    long: '10.405961',
    type: 'villa'
  },
  "property:00003" => { 
    landlord: 'landlord:00003',
    lat:'43.708067',
    long: '10.405961',
    type: 'loft'
  }
}

request = {
  "request:00001" => {
    landlord: 'landlord:00001',
    lat:'43.708067',
    long: '10.405961',
    startdate: '1481760000',
    enddate: '1482537600'
  },
    "request:00002" => {
    landlord: 'landlord:00002',
    lat:'43.782415',
    long: '11.244055',
    startdate: '1481760000',
    enddate: '1482537600'
  }
}

enable :sessions

get '/' do
  session["user"] ||= nil
  haml :index
end

get '/authenticate' do
  haml :authenticate
end

post '/authenticate' do
  if params[:psw] == user[params[:name]][:password]
    session["user"] = user[params[:name]][:uid]
    redirect '/'
  else
    "401 Unauthorized"
  end
end

get '/bye' do
  session["user"] = nil
  haml :bye
end

get '/availability' do
  if session["user"].nil?
    "401 Unauthorized"
  else
    if not params[:uid].nil?
      if availability.has_key?(params[:uid])
        JSON.generate(availability[params[:uid]])
      else
        "404 Not Found"
      end
    else
      body=JSON.generate(availability)
    end
  end 
end

get '/request' do
  if session["user"].nil?
    "401 Unauthorized"
  else
    if not params[:uid].nil?
      if request.has_key?(params[:uid])
        JSON.generate(request[params[:uid]])
      else
        "404 Not Found"
      end
    else
      body=JSON.generate(request)
    end
  end 
end

get '/property' do
  if session["user"].nil?
    "401 Unauthorized"
  else
    if not params[:uid].nil?
      if property.has_key?(params[:uid])
        JSON.generate(property[params[:uid]])
      else
        "404 Not Found"
      end
    else
      body=JSON.generate(property)
    end
  end 
end

get '/myself' do
  if session["user"].nil?
    "401 Unauthorized"
  else
    JSON.generate(landlord[session[:user]])
  end
end
