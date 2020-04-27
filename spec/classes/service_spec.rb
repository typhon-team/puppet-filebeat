require 'spec_helper'

describe 'filebeat_legacy::service' do
  let :pre_condition do
    'include ::filebeat_legacy'
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      it {
        is_expected.to contain_service('filebeat').with(
          ensure: 'running',
          enable: true,
        )
      }
    end
  end
end
