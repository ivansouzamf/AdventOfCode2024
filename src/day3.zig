const std = @import("std");
const common = @import("common.zig");

pub fn solve(allocator: std.mem.Allocator) !void {
    const input_buffer = try common.loadInput("inputs/day3.txt", allocator);

    try solvePartOne(input_buffer);
}

fn solvePartOne(input_buffer: []const u8) !void {
    var result: u32 = 0;

    for (input_buffer, 0..) |char, i| {
        _ = char;

        var instruction_str: [4]u8 = undefined;

        if (i > 3) {
            sizedMemcpy(&instruction_str, input_buffer, i - 3, 4);
            if (std.mem.eql(u8, &instruction_str, "mul(")) {
                var num1_str: [4]u8 = undefined;
                var num2_str: [4]u8 = undefined;
                @memset(&num1_str, 0);
                @memset(&num2_str, 0);

                var index = i;
                const num1_valid = parseNumbers(&num1_str, input_buffer, &index, ',');
                const num2_valid = parseNumbers(&num2_str, input_buffer, &index, ')');

                if (num1_valid and num2_valid) {
                    const num1_slice = std.mem.span(@as([*:0]u8, @ptrCast(&num1_str)));
                    const num2_slice = std.mem.span(@as([*:0]u8, @ptrCast(&num2_str)));

                    const num1 = try std.fmt.parseInt(u32, num1_slice, 10);
                    const num2 = try std.fmt.parseInt(u32, num2_slice, 10);

                    result += num1 * num2;
                }
            }
        }
    }

    std.debug.print("Part 1 result: {d}\n", .{result});
}

fn parseNumbers(num: *[4]u8, buffer: []const u8, start: *usize, stop: u8) bool {
    var is_valid = true;
    for (buffer[(start.* + 1)..], 0..) |char, i| {
        if ((!std.ascii.isDigit(char) and char != stop) or i > 3) {
            is_valid = false;
            break;
        } else if (char == stop) {
            break;
        }

        num[i] = char;
        start.* += 1;
    }

    // reincrement for the next iteration
    start.* += 1;

    return is_valid;
}

fn sizedMemcpy(target: []u8, source: []const u8, start: usize, size: usize) void {
    const max = start + size;

    var j: usize = 0;
    for (start..max) |i| {
        target[j] = source[i];
        j += 1;
    }
}
