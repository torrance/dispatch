class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.editor?
      can :manage, Article
      can [:read, :update, :moderate, :destroy], Comment
      can :create, Comment, :content_hidden? => false
      can :manage, Event
      can [:read, :update, :moderate], User # Can't create a user (except via activeadmin)
      can :manage, Page
    elsif user.active?
      can :read, :all
      can :create, Comment, :content_hidden? => false
      can :create, Article
      can :update, Article, :user_id => user.id, :locked? => false, :hidden? => false
      can :create, Event
      can :update, Event, :user_id => user.id, :locked? => false
      can :update, User, :id => user.id, :active? => true
    else
      can :read, :all
      can :create, Article
      can :create, Event
      can :create, User
      can :create, UserSession
    end
  end
end