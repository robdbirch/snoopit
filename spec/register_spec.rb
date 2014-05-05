require 'spec_helper'

describe 'Register' do

  it 'Register size 4 push_front' do
    register = Register.new 4
    register.size.should == 4
    register.push_front 1
    register.size.should == 4
    register[0].should == 1
    register[1].should == nil
    register[2].should == nil
    register[3].should == nil
    register.push_front 2
    register.size.should == 4
    register.push_front 3
    register.size.should == 4
    register.push_front 4
    register.size.should == 4
    register[0].should == 4
    register[1].should == 3
    register[2].should == 2
    register[3].should == 1
    register.push_front 5
    register[0].should == 5
    register[1].should == 4
    register[2].should == 3
    register[3].should == 2
    register[5].should eq nil
  end

  it 'Register size 1 push_front' do
    register = Register.new 1
    register.size.should == 1
    register.push_front 1
    register.size.should == 1
    register[0].should == 1
    register.size.should == 1
    register.push_front 2
    register.size.should == 1
    register[0].should == 2
  end

  it 'Register size 0 push_front' do
    register = Register.new 0
    register.size.should == 0
    register.push_front 1
    register.size.should == 0
    register.push_front 'test'
    register.size.should == 0
    register[0].should eq nil
    register[99].should eq nil
  end

  it 'Register size 4 push_back' do
    register = Register.new 4
    register.size.should == 4
    register.push_back 1
    register.size.should == 4
    register[0].should == nil
    register[1].should == nil
    register[2].should == nil
    register[3].should == 1
    register.push_back 2
    register.size.should == 4
    register.push_back 3
    register.size.should == 4
    register.push_back 4
    register.size.should == 4
    register[0].should == 1
    register[1].should == 2
    register[2].should == 3
    register[3].should == 4
    register.push_back 5
    register.size.should == 4
    register[0].should == 2
    register[1].should == 3
    register[2].should == 4
    register[3].should == 5
  end

  it 'Register size 0 push_back' do
    register = Register.new 0
    register.size.should == 0
    register.push_back 1
    register.size.should == 0
    register.push_back 'test'
    register.size.should == 0
    register[0].should eq nil
    register[99].should eq nil
  end

  it 'Test Register array assignment' do
    register = Register.new 5
    register[0] = 'foo'
    register[0].should eq 'foo'
  end

  it 'test enumerable' do
    rtest = [1,2,3,4,5]
    register = Register.new 5, rtest
    register.each_with_index { |r, i| r.should eq rtest[i] }
  end

end