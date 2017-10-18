# frozen_string_literal: true

require 'rails_helper'

describe PagesController do
  include AuthHelper

  describe '#bookings' do
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

  describe '#adjudication' do
    context 'when logged in' do
      before(:each) do
        http_login
      end

      it 'should return a 200' do
        booking = FactoryGirl.create(:booking) # controller breaks w/o at least one booking in DB

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

      it 'should return appropriate held_on_fines_pop' do
        released_booking = FactoryGirl.create(:booking, reldate: Date.yesterday)
        low_fine_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:bond_master, sysid: low_fine_booking.sysid, type_id: 'FIN', original_bond_amt: 100)
        high_fine_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:bond_master, sysid: high_fine_booking.sysid, type_id: 'FIN', original_bond_amt: 10_000)
        other_bond_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:bond_master, sysid: other_bond_booking.sysid, type_id: 'OTHER', original_bond_amt: 100)

        get :population

        expect(assigns(:held_on_fines_pop)).to eq(1)
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

      it 'should return appropriate justice_court_pop' do
        released_booking = FactoryGirl.create(:booking, reldate: Date.yesterday)
        non_justice_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:case_master,
                           booking: non_justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'NORMAL COURT'))
        justice_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:case_master,
                           booking: justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))
        multi_court_non_justice_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:case_master,
                           booking: multi_court_non_justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))
        FactoryGirl.create(:case_master,
                           booking: multi_court_non_justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'OTHER COURT'))
        multi_court_justice_booking = FactoryGirl.create(:booking, reldate: Date.parse('1900-01-01'))
        FactoryGirl.create(:case_master,
                           booking: multi_court_justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))
        FactoryGirl.create(:case_master,
                           booking: multi_court_justice_booking,
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))

        get :population

        expect(assigns(:justice_court_pop)).to eq(2)
      end

      xit 'should return appropriate justice_court_pct' do
        get :population
      end

      xit 'should return appropriate justice_court_avg_sentence' do
        FactoryGirl.create(:case_master,
                           booking: FactoryGirl.create(:booking),
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))
        FactoryGirl.create(:case_master,
                           booking: FactoryGirl.create(:booking),
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))
        FactoryGirl.create(:case_master,
                           booking: FactoryGirl.create(:booking),
                           hearing_court_name: FactoryGirl.create(:hearing_court_name, extdesc: 'JUSTICE COURT'))

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
