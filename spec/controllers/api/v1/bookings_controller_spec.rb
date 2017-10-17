require 'rails_helper'

describe Api::V1::BookingsController do
  describe '#by_agency' do
    context 'when logged in' do

      include AuthHelper
      before(:each) do
        http_login
      end

      context 'with valid params' do
        params = {
          time_start: (Date.today-3.years).beginning_of_year,
          time_end: Date.today.beginning_of_year,
        }

        it 'should return a 200' do
          get :by_agency, format: :json, params: params

          expect(response.status).to be(200)
        end

        it 'should return appropriate arresting agencies' do
          agency_with_relevant_bookings = FactoryGirl.create(:arrest, extdesc: 'Some Relevant Bookings')
          FactoryGirl.create(:booking,
            arrest: agency_with_relevant_bookings,
            comdate: params[:time_start]+10.days,
          )

          agency_with_irrelevant_bookings = FactoryGirl.create(:arrest, extdesc: 'Irrelevant Bookings')
          FactoryGirl.create(:booking,
            arrest: agency_with_irrelevant_bookings,
            comdate: params[:time_start]-10.days,
          )

          agency_without_relevant_bookings = FactoryGirl.create(:arrest, extdesc: 'No Relevant Bookings')

          get :by_agency, format: :json, params: params

          assigned_agency_ids = assigns(:agencies).map{ |agency| agency['extdesc'] }
          expect(assigned_agency_ids).to match_array([agency_with_relevant_bookings[:extdesc]])
        end

        it 'should return appropriate bookings' do
          early_booking = FactoryGirl.create(:booking, comdate: params[:time_start]-1.day)
          relevant_booking = FactoryGirl.create(:booking, comdate: Faker::Date.between(params[:time_start], params[:time_end]))
          late_booking = FactoryGirl.create(:booking, comdate: params[:time_end]+1.day)

          get :by_agency, format: :json, params: params

          expect(assigns(:bookings)).to match_array([relevant_booking])
        end
      end
    end

    context 'when not logged in' do
      it 'should respond with a 401' do
        get :by_agency

        expect(response.status).to be(401)
      end
    end
  end

  xdescribe '#over_time' do
  end

  xdescribe '#over_time_by_agency' do
  end
end
