class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.editor?
      can :read, :all
      can :manage, Article
      can :manage, Event
      can :manage, Repost
      can :manage, Page
      can [:read, :update, :moderate, :destroy], Comment
      can :create, Comment, :content_hidden? => false
      can [:read, :update, :moderate], User # Can't create a user (except via activeadmin)
    elsif user.active?
      can :read, :all
      can :create, Article
      can :update, Article, :user_id => user.id, :locked? => false, :hidden? => false
      can :create, Event
      can :update, Event, :user_id => user.id, :locked? => false
      can :create, Repost
      can :update, Repost, :user_id => user.id, :locked? => false
      can :create, Comment, :content_hidden? => false
      can :update, User, :id => user.id, :active? => true
    else
      can :read, :all
      can :create, Article
      can :create, Event
      can :create, Repost
      can :create, User
      can :create, UserSession
    end
  end
end