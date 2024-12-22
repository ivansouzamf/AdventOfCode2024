const std = @import("std");
const common = @import("common.zig");

pub fn solve(allocator: std.mem.Allocator) !void {
    const input_buffer = try common.loadInput("inputs/day2.txt", allocator);

    var safe_reports: u32 = 0;

    var line_iterator = std.mem.splitAny(u8, input_buffer, "\n");
    while (line_iterator.next()) |line| {
        var is_report_safe = true;
        var report_order = ReportOrder.none;
        var previuous_level: i32 = 0;

        var space_iterator = std.mem.splitAny(u8, line, " ");
        while (space_iterator.next()) |level_str| {
            if (level_str.len != 0) {
                const level = try std.fmt.parseInt(i32, level_str, 0);
                defer previuous_level = level;

                if (previuous_level != 0) {
                    const diff = @abs(level - previuous_level);
                    if (diff > 3 or diff < 1) {
                        is_report_safe = false;
                        break;
                    }

                    var order = ReportOrder.none;
                    defer report_order = order;

                    if (previuous_level < level) {
                        order = ReportOrder.asceding;
                    } else {
                        order = ReportOrder.desceding;
                    }

                    if (report_order != .none and report_order != order) {
                        is_report_safe = false;
                        break;
                    }
                }
            } else {
                is_report_safe = false;
                break;
            }
        }

        if (is_report_safe) {
            safe_reports += 1;
        }
    }

    std.debug.print("Part 1 result: {d}\n", .{safe_reports});
}

const ReportOrder = enum {
    none,
    asceding,
    desceding,
};
