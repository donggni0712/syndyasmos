- name: Kubernetes Initialization Playbook
  hosts: your_ec2_instances
  become: yes
  tasks:
    - name: Download init_k8s.sh script
      get_url:
        url: "http://your_script_location/init_k8s.sh"
        dest: "/tmp/init_k8s.sh"
        mode: '0755'

    - name: Execute the script
      shell: "/tmp/init_k8s.sh"
