const std = @import("std");

const day1 = @import("day1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");

pub fn main() !void {
    std.debug.print("Advent Of Code 2024 in Zig\n", .{});

    // setup allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();

    // get cmd args
    var args = try std.process.argsWithAllocator(arena_allocator);

    while (args.next()) |arg| {
        if (args.inner.index == 1) {
            continue;
        } else if (cmpArgs(arg, "day1")) {
            std.debug.print("Solving day 1\n", .{});
            try day1.solve(arena_allocator);
        } else if (cmpArgs(arg, "day2")) {
            std.debug.print("Solving day 2\n", .{});
            try day2.solve(arena_allocator);
        } else if (cmpArgs(arg, "day3")) {
            std.debug.print("Solving day 3\n", .{});
            try day3.solve(arena_allocator);
        } else {
            std.debug.print("Invalid arguments\n", .{});
            return CmdError.InvalidArgs;
        }
    }

    if (args.inner.index <= 1) {
        std.debug.print("Insuffient arguments\n", .{});
        return CmdError.InsuffientArgs;
    }
}

const CmdError = error{
    InvalidArgs,
    InsuffientArgs,
};

fn cmpArgs(arg1: []const u8, arg2: []const u8) bool {
    return std.mem.eql(u8, arg2, arg1);
}
