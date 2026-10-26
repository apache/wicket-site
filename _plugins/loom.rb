# The `loom` filter: renders a step of How Wicket works (_data/how.yml) as the homepage's component
# tree does. First the loom: Java sheets, the beads of the tree and markup sheets on shared grid
# rows, for javascript/ribbon.js to draw the ribbon through. Then the same step as a list of
# components and its files, for narrow screens and without JavaScript.
#
#   {{ step | loom: forloop.index0 }}
#
# Lines and beads no earlier step had are marked as new.
require 'strscan'

module Jekyll
  module LoomFilter
    JAVA_KEYWORDS = %w[public protected private class extends new super void return var final static this true false null].freeze
    HEIGHT = { pad: '1.2em', file: '3em', line: '1.85em', bead: '2.8em', gap: '2.2em' }.freeze
    # A bead's distance from the start of the tree column, by depth, in ch.
    DEPTH_X = [0, 14.5, 25, 38.5].freeze

    def loom(step, index)
      steps = @context.registers[:site].data['how']['steps']
      comps = @context.registers[:site].data['how']['components']
      index = index.to_i
      earlier = steps.first(index)
      had_lines = index.positive? ? file_lines(earlier) : nil
      had_beads = index.positive? ? earlier.flat_map { |s| beads_of(s).map { |b| b[:path] } } : nil
      n = index + 1

      rows = []
      sheets = []
      left = []
      right = []
      beads = []
      r = 1
      step['sheets'].each_with_index do |pair, pi|
        if pi.positive?
          rows << HEIGHT[:gap]
          r += 1
        end
        start = r
        rows << HEIGHT[:pad]
        r += 1
        file_row = r
        rows << HEIGHT[:file]
        r += 1
        last = { 'left' => file_row, 'right' => file_row }
        seen = { 'left' => Hash.new(0), 'right' => Hash.new(0) }
        beads.concat(parse_beads(pair['b'], file_row)) if pair['b']

        pair['rows'].each do |row|
          bs = parse_beads(row['b'], r)
          beads.concat(bs)
          beaded = !bs.empty?
          rows << (beaded ? HEIGHT[:bead] : HEIGHT[:line])
          [['left', 'j', 'cj'], ['right', 'h', 'ch']].each do |side, key, ckey|
            code = row[key]
            next if code.nil? || code.empty?
            name = pair[side]['name']
            seen[side][code] += 1
            fresh = had_lines && seen[side][code] > had_lines[[name, code]]
            c = row.key?(ckey) ? row[ckey] : row['c']
            (side == 'left' ? left : right) << { pi: pi, r: r, code: code, c: c, new: fresh, beaded: beaded, alone: row['thread'] == false }
            last[side] = r
          end
          r += 1
        end
        rows << HEIGHT[:pad]
        stop = r
        r += 1
        %w[left right].each do |side|
          next unless pair[side]
          col = side == 'left' ? 1 : 3
          sheets << %(<div class="sheet" style="--c:#{col}; --r:#{start} / #{[last[side] + 2, stop + 1].min}" aria-hidden="true"></div>)
          (side == 'left' ? left : right) << { pi: pi, r: file_row, file: pair[side]['name'], c: pair[side]['c'] }
        end
      end

      beads.each { |b| b[:new] = had_beads && !b[:ghost] && !had_beads.include?(b[:path]) }
      focus = step['focus'] || {}
      marks = step['marks'] || {}

      out = +''
      out << %(<div class="loom" style="grid-template-rows: #{rows.join(' ')}" aria-describedby="loom-hint")
      out << %( data-focus-paths="#{focus['paths']}" data-focus-keys="#{focus['keys']}">\n)
      out << sheets.join("\n") << "\n"
      out << loom_files(left, 1, step)
      out << %(<div class="beads" role="group" aria-label="Component tree of OrderPage after step #{n}">\n)
      beads.each { |b| out << bead_html(b, comps, marks) << "\n" }
      out << "</div>\n"
      out << loom_files(right, 3, step)
      out << %(<svg class="tree-ribbon" aria-hidden="true" focusable="false"></svg>\n</div>\n)

      real = beads.reject { |b| b[:ghost] }
      out << %(<div class="tree-list">\n<h3 class="tree-list-title">OrderPage as a tree after step #{n}</h3>\n)
      out << %(<ol class="tl">#{list_item('page', real, comps)}</ol>\n)
      out << %(<p class="tl-hint">Tap a component to light its lines in the files below. Lines marked + are new in this step.</p>\n) if real.size > 1
      out << "</div>\n"
      out << %(<div class="tree-code">\n#{list_files(step, left, right)}</div>\n)
      out
    end

    private

    def esc(s)
      s.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', '&quot;')
    end

    def span(cls, text)
      %(<span class="#{cls}">#{esc(text)}</span>)
    end

    # The lines of every file in earlier steps, counted: [file name, line] => the most
    # occurrences in one step.
    def file_lines(steps)
      most = Hash.new(0)
      steps.each do |step|
        count = Hash.new(0)
        step['sheets'].each do |pair|
          pair['rows'].each do |row|
            count[[pair['left']['name'], row['j']]] += 1 if pair['left'] && row['j'] && !row['j'].empty?
            count[[pair['right']['name'], row['h']]] += 1 if pair['right'] && row['h'] && !row['h'].empty?
          end
        end
        count.each { |k, v| most[k] = [most[k], v].max }
      end
      most
    end

    def beads_of(step)
      step['sheets'].flat_map do |pair|
        parse_beads(pair['b'], 0) + pair['rows'].flat_map { |row| parse_beads(row['b'], 0) }
      end
    end

    # "page/order/billing/street@50", "~page/message" (a tag waiting for its component)
    def parse_beads(spec, row)
      Array(spec).compact.map do |s|
        ghost = s.start_with?('~')
        path, x = s.delete_prefix('~').split('@')
        depth = path.count('/')
        { path: path, id: path.split('/').last, depth: depth, r: row, ghost: ghost,
          x: x ? x.to_f : DEPTH_X[[depth, DEPTH_X.size - 1].min] }
      end
    end

    def bead_html(b, comps, marks)
      x = b[:x] % 1 == 0 ? b[:x].to_i : b[:x]
      style = %(style="--r:#{b[:r]}; --x:#{x}")
      if b[:ghost]
        return %(<span class="bead-ghost" #{style} aria-hidden="true">#{esc(b[:id])}</span>)
      end
      comp = comps[b[:id]] || {}
      k = comp['k'] || b[:id]
      root = b[:path] == 'page'
      label = if root
                'OrderPage, the page'
              else
                inside = b[:depth] > 2 ? " inside #{b[:path].split('/')[-2]}" : ''
                %(#{comp['type']} "#{b[:id]}"#{inside} renders <#{comp['tag']} wicket:id="#{b[:id]}">)
              end
      mark = marks[b[:path]]
      label += ", with a #{mark} on its script" if mark
      cls = ['bead', ('root' if root), ('new' if b[:new])].compact.join(' ')
      text = root ? 'OrderPage' : esc(b[:id])
      text += %( <small class="bead-mark">#{esc(mark)}</small>) if mark
      %(<button type="button" class="#{cls}" #{style} data-path="#{b[:path]}" data-k="#{k}" aria-label="#{esc(label)}">#{text}</button>)
    end

    def loom_files(lines, col, step)
      by_pair = lines.group_by { |l| l[:pi] }
      by_pair.keys.sort.map do |pi|
        file, code = by_pair[pi].partition { |l| l[:file] }
        f = file.first
        cstyle = col == 3 ? '--c:3; ' : ''
        head = %(<p class="file" style="--c:#{col}; --r:#{f[:r]}"#{data_c(f[:c])}><span class="x">#{esc(f[:file])}</span></p>\n)
        body = code.sort_by { |l| l[:r] }.map do |l|
          lead = l[:code][/\A */]
          cls = ['ln', ('c' if l[:beaded]), ('new' if l[:new])].compact.join(' ')
          alone = l[:alone] ? ' data-thread="no"' : ''
          %(<span class="#{cls}" style="#{cstyle}--r:#{l[:r]}"#{data_c(l[:c])}#{alone}>#{lead}<span class="x">#{highlight(l[:code].delete_prefix(lead), f[:file])}</span></span>)
        end
        head + %(<pre class="src" aria-label="#{esc(f[:file])}"><code>#{body.join("\n")}</code></pre>\n)
      end.join
    end

    def data_c(c)
      c && !c.to_s.empty? ? %( data-c="#{c}") : ''
    end

    def list_item(path, beads, comps)
      b = beads.find { |x| x[:path] == path }
      return '' unless b
      comp = comps[b[:id]] || {}
      root = path == 'page'
      name = root ? 'OrderPage' : %("#{b[:id]}")
      kind = root ? 'page' : comp['type']
      kids = beads.select { |x| x[:path].sub(%r{/[^/]+\z}, '') == path && x[:path] != path }.sort_by { |x| x[:r] }
      inner = kids.empty? ? '' : "<ol>#{kids.map { |k| list_item(k[:path], beads, comps) }.join}</ol>"
      cls = b[:new] ? ' class="new"' : ''
      %(<li#{cls}><span class="tl-name"><b data-c="#{comp['k'] || b[:id]}">#{esc(name)}</b> <span>#{esc(kind)}</span></span>#{inner}</li>)
    end

    # The files one after another, in the order of the sheets: each pair's Java, then its markup.
    def list_files(step, left, right)
      step['sheets'].each_with_index.flat_map do |pair, pi|
        [[left, 'left'], [right, 'right']].map do |lines, side|
          next '' unless pair[side]
          name = pair[side]['name']
          code = lines.select { |l| l[:pi] == pi && !l[:file] }.sort_by { |l| l[:r] }
          body = code.map do |l|
            cls = ['tcl', ('new' if l[:new])].compact.join(' ')
            %(<span class="#{cls}"#{data_c(l[:c])}>#{highlight(l[:code], name)}</span>)
          end.join
          %(<p class="tc-file"#{data_c(pair[side]['c'])}>#{esc(name)}</p>\n<pre class="tc" tabindex="0" aria-label="#{esc(name)}"><code>#{body}</code></pre>\n)
        end
      end.join
    end

    def highlight(code, file)
      return java(code) if file.end_with?('.java')
      file.end_with?('.html') || code.match?(/<|="/) ? markup(code) : header(code)
    end

    def java(code)
      ss = StringScanner.new(code)
      out = +''
      until ss.eos?
        if ss.scan(/"(?:[^"\\]|\\.)*"/)
          # a component id or path in the ribbon's colour, other strings green
          out << span(ss.matched.match?(/\A"[A-Za-z][\w:]*"\z/) ? 'tw' : 'ts', ss.matched)
        elsif ss.scan(/@\w+/)
          out << span('tk', ss.matched)
        elsif ss.scan(/[A-Za-z_]\w*/)
          out << (JAVA_KEYWORDS.include?(ss.matched) ? span('tk', ss.matched) : esc(ss.matched))
        else
          out << esc(ss.getch)
        end
      end
      out
    end

    def markup(code)
      ss = StringScanner.new(code)
      out = +''
      until ss.eos?
        if ss.scan(%r{</?[\w:]+})
          out << span('tg', ss.matched)
        elsif ss.scan(%r{/?>})
          out << span('tg', ss.matched)
        elsif ss.scan(/(wicket:id|nonce)=("[^"]*")/)
          out << esc("#{ss[1]}=") << span('tw', ss[2])
        elsif ss.scan(/\w+=("[^"]*")/)
          out << esc(ss.matched.delete_suffix(ss[1])) << span('ts', ss[1])
        else
          out << esc(ss.getch)
        end
      end
      out
    end

    # A response header: its name, and the policy's sources; the nonce in the ribbon's colour.
    def header(code)
      ss = StringScanner.new(code)
      out = +''
      until ss.eos?
        if ss.bol? && ss.scan(/[\w-]+:(?=\s|\z)/)
          out << span('tk', ss.matched)
        elsif ss.scan(/'nonce-[^']*'/)
          out << span('tw', ss.matched)
        elsif ss.scan(/'[^']*'/)
          out << span('ts', ss.matched)
        else
          out << esc(ss.getch)
        end
      end
      out
    end
  end
end

Liquid::Template.register_filter(Jekyll::LoomFilter)
