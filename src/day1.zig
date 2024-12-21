const std = @import("std");

pub fn solve(allocator: std.mem.Allocator) !void {
    const input = "inputs/day1.txt";
    var buff: [std.fs.max_path_bytes]u8 = undefined;
    const input_path = try std.fs.realpath(input, &buff);

    const input_file = try std.fs.openFileAbsolute(input_path, .{ .mode = .read_only });
    defer input_file.close();
    const input_info = try input_file.stat();
    const input_size = input_info.size;

    const input_buffer = try allocator.alloc(u8, input_size);
    _ = try input_file.readAll(input_buffer);

    const list_size = 1000;
    var left_list = try std.ArrayList(i32).initCapacity(allocator, list_size);
    var right_list = try std.ArrayList(i32).initCapacity(allocator, list_size);

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
            num_right_slice.len = num_left_size;

            const num_left = try std.fmt.parseInt(i32, num_left_slice, 0);
            const num_right = try std.fmt.parseInt(i32, num_right_slice, 0);
            try left_list.append(num_left);
            try right_list.append(num_right);
        }
    }

    std.mem.sort(i32, left_list.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right_list.items, {}, std.sort.asc(i32));

    var result: u32 = 0;
    for (left_list.items, right_list.items) |left_num, right_num| {
        const distance = @abs(left_num - right_num);
        result += distance;
    }

    std.debug.print("Final result: {d}\n", .{result});
}
