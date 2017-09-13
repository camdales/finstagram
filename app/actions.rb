helpers do 
    def current_user
        User.find_by(id: session[:user_id])
    end
end


get '/' do 
    
    @posts = Post.order(created_at: :desc)
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

    
get '/posts/new' do
    @post = Post.new
   erb(:'posts/new')
  
end

post '/posts' do
    
    photo_url = params[:photo_url]
    
    #instantiate new Post
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    
    # if @post validates, save
    if @post.save 
        redirect(to('/'))
    else
        
        #if it doesn't validate render /posts/new
        erb(:"posts/new")
    end
end



get '/posts/:id' do
    #find  the post with the ID from the URL
    @post = Post.find(params[:id])
    
    #render app/views/posts/show.erb
    erb(:"posts/show")
end

    
post '/comments' do
    #point values from params to variables
    text = params[:text]
    post_id = params[:post_id]
    
    #instantiate a comment with those values & assign the comment to the 'current user'
    comment = Comment.new({ text: text, post_id: post_id, user_id: current_user.id})
    
    #save the comment
    comment.save
    
    
    #'redirect' back to wherever we came from
    redirect(back)
    
end


post '/likes' do
    
    post_id = params[:post_id]
    
    like = Like.new({ post_id: post_id, user_id: current_user.id })
    like.save
    
    redirect(back)
    
end

delete '/likes/:id' do
    like = Like.find(params[:id])
    like.destroy
    redirect(back)
end