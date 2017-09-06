
get '/' do 
    
    @posts = Post.order(created_at: :desc)
    @current_user = User.find_by(id: session[:user_id])
    erb(:index)

end
get '/signup' do #if a user navigates to the path "/signup",
    @user = User.new #setup empty user object 
    erb:signup #render "app/views/signup.erb"
end

post '/signup' do
    #grab user input values from params
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]
    
    
    
    @user = User.new({email: email, avatar_url: avatar_url, username: username, password: password})
    
    
    #if user validations pass and user is saved
    if @user.save 
        redirect to('/login')
    else
        erb(:signup)
    end
    
end

post '/login' do #when we submit a form with an action of /login
    username = params[:username]
    password = params[:password]
    
    
    user=User.find_by(username: username)
    

        
        if user && user.password == password 
            
            session[:user_id] = user.id
            redirect to ('/')
            
        else
            @error_message = "total failure"
            erb(:login)
        end
        
 
end

    

get '/login' do #when a GET request comes into  /login
    erb(:login) #render app/views/login.erb
    
end
    
    
get '/logout' do
    session[:user_id] = nil
    redirect to ('/')
end