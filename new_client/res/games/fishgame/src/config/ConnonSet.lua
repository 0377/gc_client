local config = {
    cannonPos = {
        { id = 1, pos = {}, posPer = { 0.33, 0.1 }, direction = 3.14, },
        { id = 2, pos = {}, posPer = { 0.725, 0.1 }, direction = 3.14, },
        { id = 3, pos = {}, posPer = { 0.67, 0.9 }, direction = 0, },
        { id = 4, pos = {}, posPer = { 0.275, 0.9 }, direction = 0, },
    },
    connonSet = {
        {
            id = 0,
            normal = 0,
            icon = 1,
            double = 1,
            cannonType = {
                --- 第一个炮
                {
                    type = 0,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao1_1v_stay", move = "bb_likui_pao1_1v" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v1" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_01_ani" },
                },
                {
                    type = 1,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao1_2v_1_stay", move = "bb_likui_pao1_2v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v2" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_02_ani" },
                },
                {
                    type = 2,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao1_3v_1_stay", move = "bb_likui_pao1_3v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v3" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_03_ani" },
                },
                --- 第二个炮
                {
                    type = 3,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao2_1v_stay", move = "bb_likui_pao2_1v" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v1" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_01_ani" },
                },
                {
                    type = 4,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao2_2v_1_stay", move = "bb_likui_pao2_2v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v2" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_02_ani" },
                },
                {
                    type = 5,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao2_3v_1_stay", move = "bb_likui_pao2_3v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v3" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_03_ani" },
                },
                --- 第三个炮
                {
                    type = 6,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao3_1v_stay", move = "bb_likui_pao3_1v" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v1" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_01_ani" },
                },
                {
                    type = 7,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao3_2v_1_stay", move = "bb_likui_pao3_2v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v2" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_02_ani" },
                },
                {
                    type = 8,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao3_3v_1_stay", move = "bb_likui_pao3_3v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v3" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_03_ani" },
                },
                --- 第四个炮
                {
                    type = 9,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao4_1v_stay", move = "bb_likui_pao4_1v" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v1" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_01_ani" },
                },
                {
                    type = 10,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao4_2v_1_stay", move = "bb_likui_pao4_2v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v2" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_02_ani" },
                },
                {
                    type = 11,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao4_3v_1_stay", move = "bb_likui_pao4_3v_1" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v3" },
                    net = { resName = "effect_fish_bomb", stay = "effect_fish_bomb_03_ani" },
                },
            }
        },
        {
            id = 1,
            normal = 0,
            icon = 1,
            double = 1,
            cannonType = {
                --- 第一个炮
                {
                    type = 0,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 1,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 2,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                --- 第二个炮
                {
                    type = 3,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 4,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 5,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                --- 第三个炮
                {
                    type = 6,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 7,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 8,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                --- 第四个炮
                {
                    type = 9,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 10,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
                {
                    type = 11,
                    cannon = { resName = "bb_likui_pao_bullet", stay = "bb_likui_pao_lz_stay", move = "bb_likui_pao_lz" },
                    bullet = { resName = "bb_likui_pao_bullet", stay = "Bullet_v4" },
                    net = { resName = "effect_fish_bomb", stay = "move" },
                },
            }
        },
    },
}


for _,v in ipairs(config.cannonPos) do
    v.pos = {
        v.posPer[1] * display.width,
        v.posPer[2] * display.height,
    }
end

return config