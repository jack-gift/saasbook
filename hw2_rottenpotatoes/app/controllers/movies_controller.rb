class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #when do i need redirect_to? 
    #1. user didn't commit new filter settings, params has no filter, and session has filter settings
    #2. no sort in params, but sesssion has it
    @redirect_ratings = false
    @redirect_sort = false
    @checked_ratings = []
    @sort = []
    
    if (params[:commit].nil? and params[:ratings].nil? and !session[:checked_ratings].nil?) 
      @checked_ratings = session[:checked_ratings]
      @redirect_ratings = true
    end
    

    #new ratings filter setting
    if !params[:commit].nil? 
      if !params[:ratings].nil?
        @checked_ratings = params[:ratings]
        session[:checked_ratings] = params[:ratings] 
      else
        session.delete(:checked_ratings) 
      end  
    else
      @checked_ratings = params[:ratings] unless params[:ratings].nil?
    end
    
    
    if  (params[:sort].nil? and !session[:sort].nil?)
      @sort = session[:sort]
      @redirect_sort = true
    end
        
        
    if !params[:sort].nil?   #use sort from sessions
       session[:sort] = params[:sort]
       @sort = params[:sort]
    end

    if @redirect_ratings or @redirect_sort
      redirect_to :sort => @sort, :ratings => @checked_ratings
    end
  


    @all_ratings = Movie.all_ratings
    if !@checked_ratings.nil? and @checked_ratings.length>0
      if @sort.nil?
        @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings.keys})
      else
        @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings.keys}, :order => @sort)
      end
    else
      if @sort.nil?
        @movies = Movie.all
      else
        @movies = Movie.order(@sort).all
      end
    end
    
    if @sort == "title"
      @title_hilite = "hilite"
    elsif @sort == "release_date"
      @reldat_hilite = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
