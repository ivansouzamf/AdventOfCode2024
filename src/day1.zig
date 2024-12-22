const std = @import("std");
const common = @import("common.zig");

pub fn solve(allocator: std.mem.Allocator) !void {
    const input_buffer = try common.loadInput("inputs/day1.txt", allocator);

    const list_size = 1000;
    var left_list = try std.ArrayList(i32).initCapacity(allocator, list_size);
    var right_list = try std.ArrayList(i32).initCapacity(allocator, list_size);

    try parseInput(input_buffer, &left_list, &right_list);

    try solvePartOne(left_list, right_list);
    try solvePartTwo(left_list, right_list);
}

fn solvePartOne(left_list: std.ArrayList(i32), right_list: std.ArrayList(i32)) !void {
    std.mem.sort(i32, left_list.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right_list.items, {}, std.sort.asc(i32));

    var result: u32 = 0;
    for (left_list.items, right_list.items) |left_num, right_num| {
        const distance = @abs(left_num - right_num);
        result += distance;
    }

    std.debug.print("Part 1 result: {d}\n", .{result});
}

fn solvePartTwo(left_list: std.ArrayList(i32), right_list: std.ArrayList(i32)) !void {
    var result: i32 = 0;
    for (left_list.items) |num_left| {
        var count: i32 = 0;
        for (right_list.items) |num_right| {
            if (num_left == num_right) {
                count += 1;
            }
        }

        const similarity = num_left * count;
        result += similarity;
    }

    std.debug.print("Part 2 result: {d}\n", .{result});
}

fn parseInput(input_buffer: []const u8, left_list: *std.ArrayList(i32), right_list: *std.ArrayList(i32)) !void {
    var line_iterator = std.mem.splitAny(u8, input_buffer, "\n");
    while (line_iterator.next()) |line| {
        const max_num_size = 15;
        var num_left_str = std.mem.zeroes([max_num_size]u8);
        var num_right_str = std.mem.zeroes([max_num_size]u8);
        var num_left_size: u32 = 0;
        var num_right_size: u32 = 0;
        var append_index: u32 = 0;
        var left_finished = false;
        for (line) |char| {
            if (char == ' ') {
                append_index = 0;
                left_finished = true;
                continue;
            }

            if (!left_finished) {
                num_left_str[append_index] = char;
                num_left_size += 1;
            } else {
                num_right_str[append_index] = char;
                num_right_size += 1;
            }
            append_index += 1;
        }

        if (num_left_size != 0 or num_right_size != 0) {
            // clamp pointer size to the actual string size
            var num_left_slice: []u8 = &num_left_str;
            num_left_slice.len = num_left_size;
            var num_right_slice: []u8 = &num_right_str;
            num_right_slice.len = num_right_size;

            const num_left = try std.fmt.parseInt(i32, num_left_slice, 0);
            const num_right = try std.fmt.parseInt(i32, num_right_slice, 0);
            try left_list.append(num_left);
            try right_list.append(num_right);
        }
    }
}
