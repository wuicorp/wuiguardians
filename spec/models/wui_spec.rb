require 'rails_helper'

describe Wui do
  it { should belong_to(:owner).class_name('User') }
  it { should belong_to(:receiver).class_name('User') }
end
