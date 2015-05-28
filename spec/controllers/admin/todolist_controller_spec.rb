require 'rails_helper'

describe Admin::TodolistController do

  describe "not logged in" do
    describe "GET 'index'" do
      it "should redirect to the login page" do
        get 'index'
        expect(response).to redirect_to("https://petition.parliament.uk/admin/login")
      end
    end
  end

  context "logged in as moderator user but need to reset password" do
    let(:user) { FactoryGirl.create(:moderator_user, :force_password_reset => true) }
    before { login_as(user) }

    it "should redirect to edit profile page" do
      expect(user.has_to_change_password?).to be_truthy
      get :index
      expect(response).to redirect_to("https://petition.parliament.uk/admin/profile/#{user.id}/edit")
    end
  end

  describe "logged in" do
    before :each do
      @p1 = FactoryGirl.create(:petition, :created_at => 3.days.ago, :state => Petition::SPONSORED_STATE)
      @p2 = FactoryGirl.create(:petition, :created_at => 12.days.ago, :state => Petition::SPONSORED_STATE)
      @p3 = FactoryGirl.create(:petition, :created_at => 7.days.ago, :state => Petition::SPONSORED_STATE)
      @p4 = FactoryGirl.create(:petition, :state => Petition::PENDING_STATE)
      @p5 = FactoryGirl.create(:open_petition)
    end

    describe "logged in as sysadmin user" do
      let(:user) { FactoryGirl.create(:sysadmin_user) }
      before { login_as(user) }

      describe "GET 'index'" do
        it "should be successful" do
          get :index
          expect(response).to be_success
        end

        it "should return all validated petitions ordered by created_at" do
          get :index
          expect(assigns[:petitions]).to eq([@p2, @p3, @p1])
        end
      end
    end

    describe "logged in as moderator user" do
      let(:user) { FactoryGirl.create(:moderator_user) }
      before { login_as(user) }

      describe "GET 'index'" do
        it "should be successful" do
          get :index
          expect(response).to be_success
        end

        it "should return all validated petitions ordered by created_at" do
          get :index
          expect(assigns[:petitions]).to eq([@p2, @p3, @p1])
        end
      end
    end

    describe "logged in as moderator user" do
      let(:user) { FactoryGirl.create(:moderator_user) }
      before { login_as(user) }

      describe "GET 'index'" do
        it "should be successful" do
          get :index
          expect(response).to be_success
        end

        it "should return all validated petitions ordered by created_at" do
          get :index
          expect(assigns[:petitions]).to eq([@p2, @p3, @p1])
        end
      end
    end
  end
end
