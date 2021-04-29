const std = @import("std");
const c = @import("main.zig").c;

pub const dict: [256]c.mu_Rect = comptime dict_gen(c.mu_Rect, 256, elements[0..], indices[0..]);

pub const white: u32 = c.MU_ICON_MAX;
pub const font: u32 = 0;
pub const scale: u16 = 1; // Scale of atlas exported from Aseprite
pub const height: u16 = 256 * scale;
pub const width: u16 = 256 * scale;

const elements = [_]c.mu_Rect{
    .{ .y = 0, .x = 0, .w = 8, .h = 16 }, // a
    .{ .y = 0, .x = 8, .w = 8, .h = 16 }, // b
    .{ .y = 0, .x = 16, .w = 8, .h = 16 }, // c
    .{ .y = 0, .x = 24, .w = 8, .h = 16 }, // d
    .{ .y = 0, .x = 32, .w = 8, .h = 16 }, // e
    .{ .y = 0, .x = 40, .w = 8, .h = 16 }, // f
    .{ .y = 0, .x = 48, .w = 8, .h = 16 }, // g
    .{ .y = 0, .x = 56, .w = 8, .h = 16 }, // h
    .{ .y = 0, .x = 64, .w = 8, .h = 16 }, // i
    .{ .y = 0, .x = 72, .w = 8, .h = 16 }, // j
    .{ .y = 0, .x = 80, .w = 8, .h = 16 }, // k
    .{ .y = 0, .x = 88, .w = 8, .h = 16 }, // l
    .{ .y = 0, .x = 96, .w = 8, .h = 16 }, // m
    .{ .y = 0, .x = 104, .w = 8, .h = 16 }, // n
    .{ .y = 0, .x = 112, .w = 8, .h = 16 }, // o
    .{ .y = 0, .x = 120, .w = 8, .h = 16 }, // p
    .{ .y = 0, .x = 128, .w = 8, .h = 16 }, // q
    .{ .y = 0, .x = 136, .w = 8, .h = 16 }, // r
    .{ .y = 0, .x = 144, .w = 8, .h = 16 }, // s
    .{ .y = 0, .x = 152, .w = 8, .h = 16 }, // t
    .{ .y = 0, .x = 160, .w = 8, .h = 16 }, // u
    .{ .y = 0, .x = 168, .w = 8, .h = 16 }, // v
    .{ .y = 0, .x = 176, .w = 8, .h = 16 }, // w
    .{ .y = 0, .x = 184, .w = 8, .h = 16 }, // x
    .{ .y = 0, .x = 192, .w = 8, .h = 16 }, // y
    .{ .y = 0, .x = 200, .w = 8, .h = 16 }, // z
    //
    .{ .y = 16, .x = 0, .w = 8, .h = 16 }, // A
    .{ .y = 16, .x = 8, .w = 8, .h = 16 }, // B
    .{ .y = 16, .x = 16, .w = 8, .h = 16 }, // C
    .{ .y = 16, .x = 24, .w = 8, .h = 16 }, // D
    .{ .y = 16, .x = 32, .w = 8, .h = 16 }, // E
    .{ .y = 16, .x = 40, .w = 8, .h = 16 }, // F
    .{ .y = 16, .x = 48, .w = 8, .h = 16 }, // G
    .{ .y = 16, .x = 56, .w = 8, .h = 16 }, // H
    .{ .y = 16, .x = 64, .w = 8, .h = 16 }, // I
    .{ .y = 16, .x = 72, .w = 8, .h = 16 }, // J
    .{ .y = 16, .x = 80, .w = 8, .h = 16 }, // K
    .{ .y = 16, .x = 88, .w = 8, .h = 16 }, // L
    .{ .y = 16, .x = 96, .w = 8, .h = 16 }, // M
    .{ .y = 16, .x = 104, .w = 8, .h = 16 }, // N
    .{ .y = 16, .x = 112, .w = 8, .h = 16 }, // O
    .{ .y = 16, .x = 120, .w = 8, .h = 16 }, // P
    .{ .y = 16, .x = 128, .w = 8, .h = 16 }, // Q
    .{ .y = 16, .x = 136, .w = 8, .h = 16 }, // R
    .{ .y = 16, .x = 144, .w = 8, .h = 16 }, // S
    .{ .y = 16, .x = 152, .w = 8, .h = 16 }, // T
    .{ .y = 16, .x = 160, .w = 8, .h = 16 }, // U
    .{ .y = 16, .x = 168, .w = 8, .h = 16 }, // V
    .{ .y = 16, .x = 176, .w = 8, .h = 16 }, // W
    .{ .y = 16, .x = 184, .w = 8, .h = 16 }, // X
    .{ .y = 16, .x = 192, .w = 8, .h = 16 }, // Y
    .{ .y = 16, .x = 200, .w = 8, .h = 16 }, // Z
    //
    .{ .y = 32, .x = 0, .w = 8, .h = 16 }, // 0
    .{ .y = 32, .x = 8, .w = 8, .h = 16 }, // 1
    .{ .y = 32, .x = 16, .w = 8, .h = 16 }, // 2
    .{ .y = 32, .x = 24, .w = 8, .h = 16 }, // 3
    .{ .y = 32, .x = 32, .w = 8, .h = 16 }, // 4
    .{ .y = 32, .x = 40, .w = 8, .h = 16 }, // 5
    .{ .y = 32, .x = 48, .w = 8, .h = 16 }, // 6
    .{ .y = 32, .x = 56, .w = 8, .h = 16 }, // 7
    .{ .y = 32, .x = 64, .w = 8, .h = 16 }, // 8
    .{ .y = 32, .x = 72, .w = 8, .h = 16 }, // 9
    //
    .{ .y = 32, .x = 80, .w = 8, .h = 16 }, // space
    .{ .y = 32, .x = 88, .w = 8, .h = 16 }, // !
    .{ .y = 32, .x = 96, .w = 8, .h = 16 }, // "
    .{ .y = 32, .x = 104, .w = 8, .h = 16 }, // #
    .{ .y = 32, .x = 112, .w = 8, .h = 16 }, // $
    .{ .y = 32, .x = 120, .w = 8, .h = 16 }, // %
    .{ .y = 32, .x = 128, .w = 8, .h = 16 }, // &
    .{ .y = 32, .x = 136, .w = 8, .h = 16 }, // '
    .{ .y = 32, .x = 144, .w = 8, .h = 16 }, // (
    .{ .y = 32, .x = 152, .w = 8, .h = 16 }, // )
    .{ .y = 32, .x = 160, .w = 8, .h = 16 }, // *
    .{ .y = 32, .x = 168, .w = 8, .h = 16 }, // +
    .{ .y = 32, .x = 176, .w = 8, .h = 16 }, // ,
    .{ .y = 32, .x = 184, .w = 8, .h = 16 }, // -
    .{ .y = 32, .x = 192, .w = 8, .h = 16 }, // .
    .{ .y = 32, .x = 200, .w = 8, .h = 16 }, // /
    .{ .y = 48, .x = 0, .w = 8, .h = 16 }, // :
    .{ .y = 48, .x = 8, .w = 8, .h = 16 }, // ;
    .{ .y = 48, .x = 16, .w = 8, .h = 16 }, // <
    .{ .y = 48, .x = 24, .w = 8, .h = 16 }, // =
    .{ .y = 48, .x = 32, .w = 8, .h = 16 }, // >
    .{ .y = 48, .x = 40, .w = 8, .h = 16 }, // ?
    .{ .y = 48, .x = 48, .w = 8, .h = 16 }, // @
    .{ .y = 48, .x = 56, .w = 8, .h = 16 }, // [
    .{ .y = 48, .x = 64, .w = 8, .h = 16 }, // \
    .{ .y = 48, .x = 72, .w = 8, .h = 16 }, // ]
    .{ .y = 48, .x = 80, .w = 8, .h = 16 }, // ^
    .{ .y = 48, .x = 88, .w = 8, .h = 16 }, // _
    .{ .y = 48, .x = 96, .w = 8, .h = 16 }, // `
    .{ .y = 48, .x = 104, .w = 8, .h = 16 }, // {
    .{ .y = 48, .x = 112, .w = 8, .h = 16 }, // |
    .{ .y = 48, .x = 120, .w = 8, .h = 16 }, // }
    .{ .y = 48, .x = 128, .w = 8, .h = 16 }, // ~
    .{ .y = 48, .x = 136, .w = 8, .h = 16 }, // missing
    //
    .{ .y = 48, .x = 144, .w = 16, .h = 16 }, // MU_ICON_CLOSE
    .{ .y = 48, .x = 160, .w = 16, .h = 16 }, // MU_ICON_CHECK
    .{ .y = 48, .x = 175, .w = 16, .h = 16 }, // MU_ICON_EXPANDED
    .{ .y = 48, .x = 192, .w = 16, .h = 16 }, // MU_ICON_COLLAPSED
    .{ .y = 0, .x = 208, .w = 3, .h = 3 }, // white
};

const indices = [_]u32{
    font + 97, // a
    font + 98, // b
    font + 99, // c
    font + 100, // d
    font + 101, // e
    font + 102, // f
    font + 103, // g
    font + 104, // h
    font + 105, // i
    font + 106, // j
    font + 107, // k
    font + 108, // l
    font + 109, // m
    font + 110, // n
    font + 111, // o
    font + 112, // p
    font + 113, // q
    font + 114, // r
    font + 115, // s
    font + 116, // t
    font + 117, // u
    font + 118, // v
    font + 119, // w
    font + 120, // x
    font + 121, // y
    font + 122, // z
    //
    font + 65, // A
    font + 66, // B
    font + 67, // C
    font + 68, // D
    font + 69, // E
    font + 70, // F
    font + 71, // G
    font + 72, // H
    font + 73, // I
    font + 74, // J
    font + 75, // K
    font + 76, // L
    font + 77, // M
    font + 78, // N
    font + 79, // O
    font + 80, // P
    font + 81, // Q
    font + 82, // R
    font + 83, // S
    font + 84, // T
    font + 85, // U
    font + 86, // V
    font + 87, // W
    font + 88, // X
    font + 89, // Y
    font + 90, // Z
    //
    font + 48, // 0
    font + 49, // 1
    font + 50, // 2
    font + 51, // 3
    font + 52, // 4
    font + 53, // 5
    font + 54, // 6
    font + 55, // 7
    font + 56, // 8
    font + 57, // 9
    //
    font + 32, // space
    font + 33, // !
    font + 34, // "
    font + 35, // #
    font + 36, // $
    font + 37, // %
    font + 38, // &
    font + 39, // '
    font + 40, // (
    font + 41, // )
    font + 42, // *
    font + 43, // +
    font + 44, // ,
    font + 45, // -
    font + 46, // .
    font + 47, // /
    font + 58, // :
    font + 59, // ;
    font + 60, // <
    font + 61, // =
    font + 62, // >
    font + 63, // ?
    font + 64, // @
    font + 91, // [
    font + 92, // \
    font + 93, // ]
    font + 94, // ^
    font + 95, // _
    font + 96, // `
    font + 123, // {
    font + 124, // |
    font + 125, // }
    font + 126, // ~
    font + 127, // missing
    //
    c.MU_ICON_CLOSE,
    c.MU_ICON_CHECK,
    c.MU_ICON_EXPANDED,
    c.MU_ICON_COLLAPSED,
    white,
};

fn dict_gen(comptime T: type, dict_len: comptime u32, els: comptime []const T, idxs: comptime []const u32) comptime [dict_len]T {
    var dict_buf: [dict_len]T = std.mem.zeroes([dict_len]T);
    for (idxs) |idx, el_idx| {
        if (el_idx < els.len) {
            const el: c.mu_Rect = els[el_idx];
            dict_buf[idx] = c.mu_Rect{ .x = el.x * scale, .y = el.y * scale, .w = el.w * scale, .h = el.h * scale };
        } else {
            break;
        }
    }
    return dict_buf;
}
