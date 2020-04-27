require 'spec_helper'

describe 'filebeat' do
  let :pre_condition do
    'include ::filebeat_legacy_legacy'
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      it { is_expected.to contain_class('filebeat') }
      it { is_expected.to contain_class('filebeat_legacy::params') }
      it { is_expected.to contain_anchor('filebeat_legacy::begin') }
      it { is_expected.to contain_anchor('filebeat_legacy::end') }
      it { is_expected.to contain_class('filebeat_legacy::install') }
      it { is_expected.to contain_class('filebeat_legacy::config') }
      it { is_expected.to contain_class('filebeat_legacy::service') }
    end
  end
end
