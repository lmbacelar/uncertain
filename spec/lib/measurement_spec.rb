require_relative '../../lib/measurement'
require_relative '../../lib/uncertainty_component'
require_relative 'ea_uncertainty_examples'

describe Measurement do

  context 'Uncertainty calculations as per EA-4/02' do

    extend  EaUncertaintyExamples::ClassMethods
    include EaUncertaintyExamples::InstanceMethods

    load_examples

    %w{s2 s3 s4 s12_14}.each do |example|
      it { should comply_with_example example }
    end
  end
end
