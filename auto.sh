#!/bin/bash

# Define the availability domains ----------------------------------------- <UPDATE> -------------------------------------------
AD1="AP-BATAM-1-AD-1"
AD2="AP-BATAM-1-AD-2"
AD3="AP-BATAM-1-AD-3"

# Array to hold availability domains
AVAILABILITY_DOMAINS=("$AD1" "$AD2" "$AD3")

# Loop indefinitely until a command succeeds
while true; do
    for AVAILABILITY_DOMAIN in "${AVAILABILITY_DOMAINS[@]}"; do
        echo "Attempting to launch instance in Availability Domain: $AVAILABILITY_DOMAIN"
        
	# ------------------------------------------------------------ <UPDATE AS NECESSARY> ------------------------------------
        oci compute instance launch \
            --availability-domain "$AVAILABILITY_DOMAIN" \
            --compartment-id "ocid1.tenancy.oc1..aaaaaaaavy6r7pugxzprwqrifbolqze5kyza66plpnm4eimnbtteblk6mrtq" \
            --shape "VM.Standard.A1.Flex" \
            --assign-private-dns-record true \
            --assign-public-ip false \
            --agent-config '{"is_management_disabled": false, "is_monitoring_disabled": false, "plugins_config": [
                {"desired_state": "DISABLED", "name": "Vulnerability Scanning"},
                {"desired_state": "DISABLED", "name": "Management Agent"},
                {"desired_state": "ENABLED", "name": "Custom Logs Monitoring"},
                {"desired_state": "DISABLED", "name": "Compute RDMA GPU Monitoring"},
                {"desired_state": "ENABLED", "name": "Compute Instance Monitoring"},
                {"desired_state": "DISABLED", "name": "Compute HPC RDMA Auto-Configuration"},
                {"desired_state": "DISABLED", "name": "Compute HPC RDMA Authentication"},
                {"desired_state": "ENABLED", "name": "Cloud Guard Workload Protection"},
                {"desired_state": "DISABLED", "name": "Block Volume Management"},
                {"desired_state": "DISABLED", "name": "Bastion"}]}' \
            --availability-config '{"recovery_action": "RESTORE_INSTANCE"}' \
            --display-name "vmku" \
            --image-id "ocid1.image.oc1.ap-batam-1.aaaaaaaadsfyvcej67zomeunleaopmabegbsytcbfiwdmfwh6klbd5zotlha" \
            --instance-options '{"are_legacy_imds_endpoints_disabled": false}' \
            --shape-config '{"memory_in_gbs": 24, "ocpus": 4}' \
            --ssh-authorized-keys-file "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoUqDvTHJAmAtW8guODJlqY4e3AyEXSFXfMiRbFKEO33j0nbqOCZ9/oRw12EEALkTb6D/ubHyXzOvy0VLuU04E1z01dBsJHWqZrrNKlkWXnrMdbt0I321wvHwI8ZOrRrE3WNIbhFsgTHmMAoAzbw+lQKtxKp/wMyZ7BBaC8FMuNTRZx4JX6KLnZO1QWrP5ETQk3lv9PqCQshv4KDPVk4sdKXt34Vjza2TvbS6aiH/FJ21DIyEpwiw/st5oo5J436N5Ros7YA4Dx4G7xLRqC2lW0DFmqWwQDhwdbNyyet+bEOf1GLXdRBYPCx4lZjrkEySlxjD787tK922SLj7DlPal ssh-key-2026-10-24"

        if [ $? -eq 0 ]; then
            echo "Instance created successfully in $AVAILABILITY_DOMAIN."
            exit 0  # Exit the script after successful execution
        else
            echo "Failed to launch instance in $AVAILABILITY_DOMAIN. Trying the next one..."
            sleep 3  # Wait 3 seconds before trying the next domain
        fi
    done
done
