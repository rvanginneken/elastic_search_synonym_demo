# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.define :elastic_synonym_demo do |elastic_synonym_demo_config|
        elastic_synonym_demo_config.vm.box = "Intracto/Debian11"

        elastic_synonym_demo_config.vm.provider "virtualbox" do |v|
            # show a display for easy debugging
            v.gui = false

            # RAM size
            v.memory = 2048

            # Allow symlinks on the shared folder
            v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

            # Share host VPN connections with guest
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end

        # allow external connections to the machine
        #elastic_synonym_demo_config.vm.forward_port 80, 8080

        # Shared folder over NFS
        elastic_synonym_demo_config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'nolock', 'actimeo=2']

        elastic_synonym_demo_config.vm.network "private_network", ip: "192.168.33.211"

        # Provice access to Intracto Gitlab with the SSH key of your host machine
        elastic_synonym_demo_config.ssh.forward_agent = true

        # Shell provisioning
        elastic_synonym_demo_config.vm.provision :shell, :path => "shell_provisioner/run.sh"
    end
end
