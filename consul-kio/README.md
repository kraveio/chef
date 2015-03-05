# consul-kio-cookbook

provides a simple wrapper around the consul cookbook. 

## Supported Platforms

* Amazon Linux
* CentOS / RedHat
* Ubuntu / Debian

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['consul']['bootstrap_expect']</tt></td>
    <td>Integer</td>
    <td>The number of servers to expect for quorum.</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['consul']['serve_ui']</tt></td>
    <td>Boolean</td>
    <td>Should the agent serve the web ui?</td>
    <td><tt>true</tt> if a server agent</td>
  </tr>
  <tr>
    <td><tt>['consul']['servers']</tt></td>
    <td>Array of Strings</td>
    <td>The ip addresses of all servers participating in quorum.</td>
    <td><tt>OpsworksIPS</tt> if on AWS Opsworks</td>
  </tr>
  <tr>
    <td><tt>[:consul_kio][:layers][:consul]</tt></td>
    <td>String</td>
    <td>The OpsWorks Layername to retrieve the server IPs for</td>
    <td><tt>consul</tt></td>
  </tr>

</table>

## Usage

### consul-kio::client

The client recipe installs the consul agent on the client machine.  

If run on aws opsworks and the layer name is consul then there is no other configuration required.

However, you will most likely want to add service definitions to: `/etc/consul.d/`

### consul-kio::server

The server recipe requires setting the number of servers that will participate in the quorum.
Like the client, if run in aws opsworks there are no other settings required. 

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
