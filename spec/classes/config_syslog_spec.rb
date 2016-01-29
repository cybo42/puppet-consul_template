require 'spec_helper'

describe 'consul_template', :type => :class do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "don't configure syslog if not enabled (default) on OS family #{osfamily}" do
        let(:params) {{
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to_not contain_concat__fragment('syslog') }
      end

      describe "configure syslog if enabled on OS family #{osfamily}" do
        let(:params) {{
          :syslog_enabled => true
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_concat__fragment('syslog') }
        it { is_expected.to contain_concat__fragment('syslog').with ({
          :content => "syslog {\n  enabled = true\n  facility = \"LOCAL0\"\n}\n\n",
        })}
      end

      describe "configure syslog log facility if enabled and set on OS family #{osfamily}" do
        let(:params) {{
          :syslog_enabled => true,
          :syslog_facility => 'LOCAL3'
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :concat_basedir => '/foo',
          :path           => '/bin:/sbin:/usr/bin:/usr/sbin',
          :architecture   => 'x86_64'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_concat__fragment('syslog') }
        it { is_expected.to contain_concat__fragment('syslog').with ({
          :content => "syslog {\n  enabled = true\n  facility = \"LOCAL3\"\n}\n\n",
        })}
      end


    end
  end
end
