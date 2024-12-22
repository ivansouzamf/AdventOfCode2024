const std = @import("std");

pub fn loadInput(input: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    var buff: [std.fs.max_path_bytes]u8 = undefined;
    const input_path = try std.fs.realpath(input, &buff);

    const input_file = try std.fs.openFileAbsolute(input_path, .{ .mode = .read_only });
    defer input_file.close();
    const input_info = try input_file.stat();
    const input_size = input_info.size;

    const input_buffer = try allocator.alloc(u8, input_size);
    _ = try input_file.readAll(input_buffer);

    return input_buffer;
}
