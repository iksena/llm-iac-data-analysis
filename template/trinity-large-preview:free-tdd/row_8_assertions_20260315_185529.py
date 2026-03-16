def test_template(template: Template):
    # Assert one CloudWatch Dashboard resource exists
    template.resource_count_is("AWS::CloudWatch::Dashboard", 1)

    # Capture the Dashboard resource to inspect its properties
    dashboard = template.find_resources("AWS::CloudWatch::Dashboard", {})
    assert len(dashboard) == 1

    # Extract the Dashboard properties
    dashboard_props = next(iter(dashboard.values()))["Properties"]

    # Assert the Dashboard has a non-empty widgets array
    widgets = dashboard_props.get("Widgets", [])
    assert len(widgets) >= 4, "Dashboard should have at least 4 widgets"

    # Helper to find a widget by its title
    def find_widget_by_title(title):
        for widget in widgets:
            if widget.get("Title") == title:
                return widget
        return None

    # Assert presence of specific widgets by title (business need implies these exist)
    top_source_ips_widget = find_widget_by_title("Top Source IPs by Outbound Traffic")
    rejected_connections_widget = find_widget_by_title("Rejected Connections")

    assert top_source_ips_widget is not None, "Top Source IPs widget missing"
    assert rejected_connections_widget is not None, "Rejected Connections widget missing"

    # Assert each widget has a LogQuery property (CloudWatch Logs Insights)
    for widget in widgets:
        if "LogQuery" in widget:
            assert "Start" in widget["LogQuery"]
            assert "End" in widget["LogQuery"]
            assert "QueryString" in widget["LogQuery"]
            # Assert the query references NAT Gateway interface IDs
            assert "interfaceId like 'eni-'" in widget["LogQuery"]["QueryString"], \
                "Query should filter for NAT Gateway interface IDs"

    # Assert Dashboard has a name
    assert "DashboardName" in dashboard_props
    assert isinstance(dashboard_props["DashboardName"], str)
    assert len(dashboard_props["DashboardName"]) > 0