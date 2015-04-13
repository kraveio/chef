#!/bin/bash

brew install terraform

ssh -f -N -L 12022:${aws_instance.chef.private_ip}:22 ec2-user@${aws_instance.jump.public_ip} -o StrictHostKeyChecking=no

