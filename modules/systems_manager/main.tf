/************************************************************
Documents
************************************************************/
### Change Calender
resource "aws_ssm_document" "change_calender" {
  name            = "auto-open-close-calender"
  document_type   = "ChangeCalendar"
  document_format = "TEXT"
  content         = <<-EOT
    BEGIN:VCALENDAR
    PRODID:-//AWS//Change Calendar 1.0//EN
    VERSION:2.0
    X-CALENDAR-TYPE:DEFAULT_CLOSED
    X-WR-CALDESC:Calendar for managing automated opening and closing stations
    X-CALENDAR-CMEVENTS:DISABLED
    BEGIN:VEVENT
    UID:open-close
    SEQUENCE:0
    SUMMARY:open-event
    DESCRIPTION:Operating hours
    DTSTART;TZID=Asia/Tokyo:20260501T080000
    DTEND;TZID=Asia/Tokyo:20260501T180000
    RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR
    X-EVENT-TYPE:STANDARD
    END:VEVENT
    END:VCALENDAR
  EOT
  tags = {
    Name = "auto-open-close-calender"
  }
}

### Automation runbook
resource "aws_ssm_document" "automation" {
  name            = "Custom-AutoOpenClose"
  document_type   = "Automation"
  document_format = "YAML"
  content         = file("${path.module}/config/automation.yaml")
  tags = {
    Name = "Custom-AutoOpenClose"
  }
}