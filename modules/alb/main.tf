/************************************************************
Target Group
************************************************************/
resource "aws_lb_target_group" "this" {
  name             = "ec2-tg"
  target_type      = "instance"
  protocol         = "HTTP"
  port             = 80
  ip_address_type  = "ipv4"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"
  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3 # default 5
    unhealthy_threshold = 2 # default 2
    # must timeout<interval
    timeout  = 5  # default 5
    interval = 10 # default 30
    matcher  = "200"
  }
  tags = {
    Name = "ec2-tg"
  }
  ### Attributes
  ## Target deregistration management
  deregistration_delay = "300"
  ## Traffic configuration
  load_balancing_algorithm_type = "round_robin"
  slow_start                    = 0
  ## Target selection configuration
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  load_balancing_anomaly_mitigation = "off"
  ## Target group health requirements
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

/************************************************************
Target Group Attachment
************************************************************/
resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  port             = 80
  target_id        = var.instance_id
}

/************************************************************
ALB
************************************************************/
resource "aws_lb" "this" {
  name               = "internet-alb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"
  subnets = [
    var.subnet_ids["public_1a"],
    var.subnet_ids["public_1c"]
  ]
  security_groups = [
    var.sg_id
  ]
  tags = {
    Name = "internet-alb"
  }
  ### Attributes
  ## Traffic configuration
  enable_tls_version_and_cipher_suite_headers = false
  enable_waf_fail_open                        = false
  enable_http2                                = true
  idle_timeout                                = 60
  client_keep_alive                           = 3600
  ## Packet handling
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = false
  xff_header_processing_mode = "append"
  enable_xff_client_port     = false
  preserve_host_header       = false
  ## Availability Zone routing configuration
  enable_cross_zone_load_balancing = true
  enable_zonal_shift               = false
  ## Protection
  enable_deletion_protection = false
  ## Logging
  access_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
  connection_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
  health_check_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
}

/************************************************************
Listener
************************************************************/
resource "aws_lb_listener" "http" {
  load_balancer_arn                    = aws_lb.this.arn
  protocol                             = "HTTP"
  port                                 = 80
  routing_http_response_server_enabled = true
  tags = {
    Name = "http-listener"
  }
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
      message_body = "Forbidden..."
    }
  }
}

/************************************************************
Listener Rule
************************************************************/
resource "aws_lb_listener_rule" "host" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2 # 1-5000
  tags = {
    Name = "host"
  }
  condition {
    host_header {
      regex_values = []
      values       = ["*.${var.region}.elb.amazonaws.com"]
    }
  }
  action {
    order = 1
    type  = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.this.arn
        weight = 1
      }
      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

}

resource "aws_lb_listener_rule" "sorry" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100 # 1-5000
  tags = {
    Name = "sorry"
  }
  condition {
    path_pattern {
      regex_values = []
      values       = ["/*"]
    }
  }
  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = file("${path.module}/config/sorry_page.txt")
      status_code  = "503"
    }
  }
}