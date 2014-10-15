require 'active_support/all'
require 'herdis'

describe Herdis do
  before :each do
    Herdis.lookup_store_client = double('store_lookup_client')
  end
  context 'lookup attributes' do
    it 'should generate declarative attributes on the model with simple lookup value' do
      class Employee
        include Herdis
        attr_accessor :id
        lookup :name, using= :id

        def initialize(id)
          @id = id
        end
      end
      expect(Herdis.lookup_store_client).to receive(:get).with('ids/1').and_return('Employee Name')
      e = Employee.new(1)
      expect(e.name).to eq('Employee Name')
    end

    it 'should generate declarative attributes on the model with object based lookup value' do
      class Employee
        include Herdis
        attr_accessor :id
        lookup [:name, :location], using=:id

        def initialize(id)
          @id = id
        end
      end

      expect(Herdis.lookup_store_client).to receive(:get).with('ids/1')
              .and_return({'name' => 'Employee Name', 'location' => 'Chennai'}.to_json)
      e = Employee.new(1)
      expect(e.name).to eq('Employee Name')
      expect(e.location).to eq('Chennai')
    end
  end
end