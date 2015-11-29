def guit_a(opts)
  sample :guit_em9, rate: opts[:rate]
end

def p_c
  2.times do
    play :C3, pan: -1, amp: 1
    sleep 0.5
  end
  2.times do
    play :D2, pan: 1, amp: 1, release: 3
    sleep 0.5
  end
  sleep 4
end

def li_1
  sleep 12
  live_loop :pl_2 do
  with_fx :compressor do
  sample :loop_industrial, start: 0.3, rate: 0.6,
    cutoff: 60, res: 0.8, decay: 1
  end
  sleep 3
  end
end

in_thread do
  live_loop :guit do
    4.times do
      with_fx :echo, mix: 0.3, phase: 0.25 do
        sample :guit_em9, rate: -0.5
      end
      sleep 8

      with_fx :echo, mix: 0.6, phase: 0.25 do
        sample :guit_em9, rate: -0.5
      end
      sleep 4
    end
    sleep 4
  end
end

live_loop :boom do
  sync :guit
  with_fx :reverb, room: 1 do
    sample :bd_boom, amp: 10, rate: 1
  end
  sleep 8

  li_2
end

in_thread do
  sync :guit
  16.times do
    4.times do
      guit_a({rate: 0.5})
      sleep 8
    end

    loop do
      sleep 4
      p_c
      guit_a({rate: 1})

      sleep 4
      8.times do
        8.times do
          play chord(:E3, :minor).choose, pan: -1, release: 2, attack: 2
          sleep 0.2
        end

        8.times do
          play chord(:E3, :minor).choose, pan: 1, release: 2, attack: 2
          sleep 0.2
        end
        sleep 4
      end
    end
  end

  in_thread do
    live_loop :s1 do
      with_synth :mod_sine do
        play 43, mod_wave: 2, mod_range: 0.2
        sleep 1
        play 42
        sleep 1
      end
    end
  end
end