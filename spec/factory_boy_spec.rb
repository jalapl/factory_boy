require 'spec_helper'

class User
  attr_accessor :first_name, :last_name, :admin
end

describe FactoryBoy do
  let(:define_invalid_attributes_factory) do
    FactoryBoy.define do
      factory :user do
        surname 'Testowy'
      end
    end
  end

  let(:define_invalid_class_factory) do
    FactoryBoy.define do
      factory :admin do
      end
    end
  end

  let(:define_valid_factory) do
    FactoryBoy.define do
      factory :user do
        first_name 'Jacek'
        last_name  { 'Lachowski' }
        admin false
      end
    end
  end

  let(:define_valid_factory_with_class_attribute) do
    FactoryBoy.define do
      factory :admin, class: User do
        first_name 'Jacek'
        last_name  { 'Lachowski' }
        admin true
      end
    end
  end

  describe 'when I define a factory' do
    describe 'and I pass an existing class name' do
      describe 'with available class attributes' do
        it 'defines a new factory' do
          define_valid_factory
          expect(FactoryBoy.factories[:user]).not_to be_nil
        end

        it 'assigns default values to the factory' do
          define_valid_factory
          user_factory = FactoryBoy.factories[:user]
          expect(user_factory.defaults[:first_name]).to eq('Jacek')
          expect(user_factory.defaults[:last_name]).to eq('Lachowski')
          expect(user_factory.klass).to eq(User)
        end
      end

      describe 'with unavailable class attributes' do
        it 'raises unknown attribute exception' do
          expect { define_invalid_attributes_factory }.to raise_error(FactoryBoy::UnknownClassAttributeError)
        end
      end
    end

    describe 'and I pass an additional class param' do
      describe 'with available class attribute' do
        it 'defines a new factory' do
          define_valid_factory_with_class_attribute
          admin_factory = FactoryBoy.factories[:admin]
          expect(admin_factory).not_to be_nil
          expect(admin_factory.klass).to eq(User)
        end
      end
    end

    describe 'and I pass a nonexisting class name' do
      it 'raises unknown class name exception' do
        expect { define_invalid_class_factory }.to raise_error(FactoryBoy::UnknownClassNameError)
      end
    end
  end

  describe '#build' do
    before do
      define_valid_factory_with_class_attribute
      define_valid_factory
    end

    it 'returns user with default attributes' do
      user = FactoryBoy.build(:user)
      expect(user).to be_instance_of(User)
      expect(user.first_name).to eq('Jacek')
      expect(user.last_name).to eq('Lachowski')
      expect(user.admin).to eq(false)
    end

    it 'returns admin with default attributes' do
      user = FactoryBoy.build(:admin)
      expect(user).to be_instance_of(User)
      expect(user.first_name).to eq('Jacek')
      expect(user.last_name).to eq('Lachowski')
      expect(user.admin).to eq(true)
    end

    it 'raises undefined factory exception when we pass an invalid factory' do
      expect { FactoryBoy.build(:client) }.to raise_error(FactoryBoy::UndefinedFactoryError)
    end

    describe 'when I overwrite default values' do
      it 'returns user with overwritten default attributes' do
        user = FactoryBoy.build(:user, first_name: 'Test')
        expect(user).to be_instance_of(User)
        expect(user.first_name).to eq('Test')
        expect(user.last_name).to eq('Lachowski')
        expect(user.admin).to eq(false)
      end
    end
  end
end
