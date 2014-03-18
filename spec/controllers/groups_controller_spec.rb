require 'spec_helper'

describe GroupsController do
  let(:group) { build :group }
  let(:groups) { [group] }

  before do
    Group.stub(:roots) { groups }
    Group.stub(:find) { group }
  end

  describe 'GET #index' do
    before do
      get :index, format: :json
    end

    it 'shows the groups as json' do
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    context 'when group has no children' do
      before do
        get :show, id: 'id'
      end

      it 'responds successfully' do
        expect(response).to be_success
      end

      it 'assigns group' do
        expect(assigns(:group)).to eq(group)
      end
    end

    context 'when group has children' do
      before do
        group.stub(:children?) { true }
        get :show, id: 'id'
      end

      it 'should redirect to search' do
        expect(response).to redirect_to(search_path)
      end
    end
  end
end
