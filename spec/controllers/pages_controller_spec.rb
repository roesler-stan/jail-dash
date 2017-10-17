require 'rails_helper'

describe PagesController do
  include AuthHelper

  xdescribe '#bookings' do
    context 'when logged in' do

      before(:each) do
        http_login
      end

      it 'should return a 200' do
        get :bookings

        expect(response.status).to be(200)
      end
    end
  end

  xdescribe '#adjudication' do
    context 'when logged in' do

      before(:each) do
        http_login
      end

      it 'should return a 200' do
        get :adjudication

        expect(response.status).to be(200)
      end
    end
  end

  describe '#population' do
    context 'when logged in' do

      before(:each) do
        http_login
      end

      it 'should return a 200' do
        booking = FactoryGirl.create(:booking) # controller breaks w/o at least one booking in DB

        get :population

        expect(response.status).to be(200)
      end

      it 'should return appropriate total_jail_population' do
        released_booking = FactoryGirl.create(:booking, reldate: Date.yesterday)
        current_booking_1 = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        current_booking_2 = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))

        get :population

        expect(assigns(:total_jail_population)).to eq(2)
      end

      it 'should return appropriate inhouse_jail_population' do
        released_booking = FactoryGirl.create(:booking, jlocat: 'MAIN', reldate: Date.yesterday)
        outofhouse_booking = FactoryGirl.create(:booking, jlocat: 'Distant Town', reldate: Date.parse('1900-01-01'))
        current_booking_1 = FactoryGirl.create(:booking, jlocat: 'MAIN', reldate: Date.parse('1900-01-01'))
        current_booking_2 = FactoryGirl.create(:booking, jlocat: 'MAIN', reldate: Date.parse('1900-01-01'))

        get :population

        expect(assigns(:inhouse_jail_population)).to eq(2)
      end

      xit 'should return appropriate held_on_fines_pop' do
        get :population
      end

      xit 'should return appropriate held_on_fines_pct' do
        get :population
      end

      xit 'should return appropriate held_on_fines_avg_sentence' do
        get :population
      end

      xit 'should return appropriate condition_of_probation_pop' do
        get :population
      end

      xit 'should return appropriate condition_of_probation_pct' do
        get :population
      end

      xit 'should return appropriate condition_of_probation_avg_sentence' do
        get :population
      end

      xit 'should return appropriate justice_court_pop' do
        get :population
      end

      xit 'should return appropriate justice_court_pct' do
        get :population
      end

      xit 'should return appropriate justice_court_avg_sentence' do
        get :population
      end

      xit 'should return appropriate justice_court_stats_by_court' do
        get :population
      end
    end

    context 'when not logged in' do
      it 'should respond with a 401' do
        get :population

        expect(response.status).to be(401)
      end
    end
  end
end
