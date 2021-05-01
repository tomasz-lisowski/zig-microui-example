const std = @import("std");
const c = @import("main.zig").c;

// Description of a glyph on the atlas i.e. a rectangle on the atlas which
// contains pixels of a glyph that can be found at  the 'idx' in the atlas dict.
const AtlasGlyph = struct {
    idx: u8,
    rect: c.mu_Rect,
};

pub const dict: [256]c.mu_Rect = atlasDictGen(256, elements[0..]);

pub const white: u32 = c.MU_ICON_MAX;
pub const font: u32 = 0;
pub const scale: u16 = 1; // Scale of atlas exported from Aseprite
pub const height: u16 = 256 * scale;
pub const width: u16 = 256 * scale;

fn atlasRect(x: u32, y: u32, w: u32, h: u32) c.mu_Rect {
    return .{ .y = @intCast(c_int, y), .x = @intCast(c_int, x), .w = @intCast(c_int, w), .h = @intCast(c_int, h) };
}

fn atlasGlyph(atlas_idx: u8, rect: c.mu_Rect) AtlasGlyph {
    return AtlasGlyph{ .idx = atlas_idx, .rect = rect };
}

fn atlasDictGen(comptime dict_len: u32, comptime els: []const AtlasGlyph) [dict_len]c.mu_Rect {
    var dict_buf: [dict_len]c.mu_Rect = std.mem.zeroes([dict_len]c.mu_Rect);
    for (els) |el| {
        const rect: c.mu_Rect = el.rect;
        dict_buf[el.idx] = c.mu_Rect{ .x = rect.x * scale, .y = rect.y * scale, .w = rect.w * scale, .h = rect.h * scale };
    }
    return dict_buf;
}

const elements = [_]AtlasGlyph{
    atlasGlyph(font + 'a', atlasRect(0, 0, 8, 16)),
    atlasGlyph(font + 'b', atlasRect(8, 0, 8, 16)),
    atlasGlyph(font + 'c', atlasRect(16, 0, 8, 16)),
    atlasGlyph(font + 'd', atlasRect(24, 0, 8, 16)),
    atlasGlyph(font + 'e', atlasRect(32, 0, 8, 16)),
    atlasGlyph(font + 'f', atlasRect(40, 0, 8, 16)),
    atlasGlyph(font + 'g', atlasRect(48, 0, 8, 16)),
    atlasGlyph(font + 'h', atlasRect(56, 0, 8, 16)),
    atlasGlyph(font + 'i', atlasRect(64, 0, 8, 16)),
    atlasGlyph(font + 'j', atlasRect(72, 0, 8, 16)),
    atlasGlyph(font + 'k', atlasRect(80, 0, 8, 16)),
    atlasGlyph(font + 'l', atlasRect(88, 0, 8, 16)),
    atlasGlyph(font + 'm', atlasRect(96, 0, 8, 16)),
    atlasGlyph(font + 'n', atlasRect(104, 0, 8, 16)),
    atlasGlyph(font + 'o', atlasRect(112, 0, 8, 16)),
    atlasGlyph(font + 'p', atlasRect(120, 0, 8, 16)),
    atlasGlyph(font + 'q', atlasRect(128, 0, 8, 16)),
    atlasGlyph(font + 'r', atlasRect(136, 0, 8, 16)),
    atlasGlyph(font + 's', atlasRect(144, 0, 8, 16)),
    atlasGlyph(font + 't', atlasRect(152, 0, 8, 16)),
    atlasGlyph(font + 'u', atlasRect(160, 0, 8, 16)),
    atlasGlyph(font + 'v', atlasRect(168, 0, 8, 16)),
    atlasGlyph(font + 'w', atlasRect(176, 0, 8, 16)),
    atlasGlyph(font + 'x', atlasRect(184, 0, 8, 16)),
    atlasGlyph(font + 'y', atlasRect(192, 0, 8, 16)),
    atlasGlyph(font + 'z', atlasRect(200, 0, 8, 16)),
    //
    atlasGlyph(font + 'A', atlasRect(0, 16, 8, 16)),
    atlasGlyph(font + 'B', atlasRect(8, 16, 8, 16)),
    atlasGlyph(font + 'C', atlasRect(16, 16, 8, 16)),
    atlasGlyph(font + 'D', atlasRect(24, 16, 8, 16)),
    atlasGlyph(font + 'E', atlasRect(32, 16, 8, 16)),
    atlasGlyph(font + 'F', atlasRect(40, 16, 8, 16)),
    atlasGlyph(font + 'G', atlasRect(48, 16, 8, 16)),
    atlasGlyph(font + 'H', atlasRect(56, 16, 8, 16)),
    atlasGlyph(font + 'I', atlasRect(64, 16, 8, 16)),
    atlasGlyph(font + 'J', atlasRect(72, 16, 8, 16)),
    atlasGlyph(font + 'K', atlasRect(80, 16, 8, 16)),
    atlasGlyph(font + 'L', atlasRect(88, 16, 8, 16)),
    atlasGlyph(font + 'M', atlasRect(96, 16, 8, 16)),
    atlasGlyph(font + 'N', atlasRect(104, 16, 8, 16)),
    atlasGlyph(font + 'O', atlasRect(112, 16, 8, 16)),
    atlasGlyph(font + 'P', atlasRect(120, 16, 8, 16)),
    atlasGlyph(font + 'Q', atlasRect(128, 16, 8, 16)),
    atlasGlyph(font + 'R', atlasRect(136, 16, 8, 16)),
    atlasGlyph(font + 'S', atlasRect(144, 16, 8, 16)),
    atlasGlyph(font + 'T', atlasRect(152, 16, 8, 16)),
    atlasGlyph(font + 'U', atlasRect(160, 16, 8, 16)),
    atlasGlyph(font + 'V', atlasRect(168, 16, 8, 16)),
    atlasGlyph(font + 'W', atlasRect(176, 16, 8, 16)),
    atlasGlyph(font + 'X', atlasRect(184, 16, 8, 16)),
    atlasGlyph(font + 'Y', atlasRect(192, 16, 8, 16)),
    atlasGlyph(font + 'Z', atlasRect(200, 16, 8, 16)),
    //
    atlasGlyph(font + '0', atlasRect(0, 32, 8, 16)),
    atlasGlyph(font + '1', atlasRect(8, 32, 8, 16)),
    atlasGlyph(font + '2', atlasRect(16, 32, 8, 16)),
    atlasGlyph(font + '3', atlasRect(24, 32, 8, 16)),
    atlasGlyph(font + '4', atlasRect(32, 32, 8, 16)),
    atlasGlyph(font + '5', atlasRect(40, 32, 8, 16)),
    atlasGlyph(font + '6', atlasRect(48, 32, 8, 16)),
    atlasGlyph(font + '7', atlasRect(56, 32, 8, 16)),
    atlasGlyph(font + '8', atlasRect(64, 32, 8, 16)),
    atlasGlyph(font + '9', atlasRect(72, 32, 8, 16)),
    //
    atlasGlyph(font + ' ', atlasRect(80, 32, 8, 16)),
    atlasGlyph(font + '!', atlasRect(88, 32, 8, 16)),
    atlasGlyph(font + '"', atlasRect(96, 32, 8, 16)),
    atlasGlyph(font + '#', atlasRect(104, 32, 8, 16)),
    atlasGlyph(font + '$', atlasRect(112, 32, 8, 16)),
    atlasGlyph(font + '%', atlasRect(120, 32, 8, 16)),
    atlasGlyph(font + '&', atlasRect(128, 32, 8, 16)),
    atlasGlyph(font + '\'', atlasRect(136, 32, 8, 16)),
    atlasGlyph(font + '(', atlasRect(144, 32, 8, 16)),
    atlasGlyph(font + ')', atlasRect(152, 32, 8, 16)),
    atlasGlyph(font + '*', atlasRect(160, 32, 8, 16)),
    atlasGlyph(font + '+', atlasRect(168, 32, 8, 16)),
    atlasGlyph(font + ',', atlasRect(176, 32, 8, 16)),
    atlasGlyph(font + '-', atlasRect(184, 32, 8, 16)),
    atlasGlyph(font + '.', atlasRect(192, 32, 8, 16)),
    atlasGlyph(font + '/', atlasRect(200, 32, 8, 16)),
    atlasGlyph(font + ':', atlasRect(0, 48, 8, 16)),
    atlasGlyph(font + ';', atlasRect(8, 48, 8, 16)),
    atlasGlyph(font + '<', atlasRect(16, 48, 8, 16)),
    atlasGlyph(font + '=', atlasRect(24, 48, 8, 16)),
    atlasGlyph(font + '>', atlasRect(32, 48, 8, 16)),
    atlasGlyph(font + '?', atlasRect(40, 48, 8, 16)),
    atlasGlyph(font + '@', atlasRect(48, 48, 8, 16)),
    atlasGlyph(font + '[', atlasRect(56, 48, 8, 16)),
    atlasGlyph(font + '\\', atlasRect(64, 48, 8, 16)),
    atlasGlyph(font + ']', atlasRect(72, 48, 8, 16)),
    atlasGlyph(font + '^', atlasRect(80, 48, 8, 16)),
    atlasGlyph(font + '_', atlasRect(88, 48, 8, 16)),
    atlasGlyph(font + '`', atlasRect(96, 48, 8, 16)),
    atlasGlyph(font + '{', atlasRect(104, 48, 8, 16)),
    atlasGlyph(font + '|', atlasRect(112, 48, 8, 16)),
    atlasGlyph(font + '}', atlasRect(120, 48, 8, 16)),
    atlasGlyph(font + '~', atlasRect(128, 48, 8, 16)),
    atlasGlyph(font + 127, atlasRect(136, 48, 8, 16)), // missing
    //
    atlasGlyph(c.MU_ICON_CLOSE, atlasRect(144, 48, 16, 16)),
    atlasGlyph(c.MU_ICON_CHECK, atlasRect(160, 48, 16, 16)),
    atlasGlyph(c.MU_ICON_EXPANDED, atlasRect(175, 48, 16, 16)),
    atlasGlyph(c.MU_ICON_COLLAPSED, atlasRect(192, 48, 16, 16)),
    atlasGlyph(white, atlasRect(208, 0, 3, 3)),
};
