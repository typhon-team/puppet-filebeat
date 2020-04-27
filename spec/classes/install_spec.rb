require 'spec_helper'

describe 'filebeat_legacy::install' do
  let :pre_condition do
    'include ::filebeat_legacy'
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      it { is_expected.to contain_anchor('filebeat_legacy::install::begin') }
      it { is_expected.to contain_anchor('filebeat_legacy::install::end') }

      case os_facts[:kernel]
      when 'Linux'
        it { is_expected.to contain_class('filebeat_legacy::install::linux') }
        it { is_expected.to contain_class('filebeat_legacy::repo') }
        it { is_expected.not_to contain_class('filebeat_legacy::install::windows') }

      when 'Windows'
        it { is_expected.to contain_class('filebeat_legacy::install::windows') }
        it { is_expected.not_to contain_class('filebeat_legacy::install::linux') }
      end
    end
  end
end
