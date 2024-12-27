import os
import time
import pkg_resources
from janus_swi import query_once, consult
from functools import cache
from contextlib import contextmanager
from . util import order_prog, prog_is_recursive, rule_is_recursive, calc_rule_size, calc_prog_size, prog_hash, format_rule, format_literal
from bitarray import bitarray, frozenbitarray


def bool_query(query):
    return query_once(query)['truth']

class Tester():

    def __init__(self, settings):
        self.settings = settings

        bk_pl_path = self.settings.bk_file
        exs_pl_path = self.settings.ex_file
        test_pl_path = pkg_resources.resource_filename(__name__, "lp/test.pl")

        # if not settings.pi_enabled:
        consult('prog', f':- dynamic {settings.head_literal.predicate}/{len(settings.head_literal.arguments)}.')

        for x in [exs_pl_path, bk_pl_path, test_pl_path]:
            if os.name == 'nt': # if on Windows, SWI requires escaped directory separators
                x = x.replace('\\', '\\\\')
            consult(x)

        query_once('load_examples')

        self.num_pos = query_once('findall(_K, pos_index(_K, _Atom), _S), length(_S, N)')['N']
        self.num_neg = query_once('findall(_K, neg_index(_K, _Atom), _S), length(_S, N)')['N']

        self.pos_examples_ = bitarray(self.num_pos)
        self.pos_examples_.setall(1)

        self.cached_pos_covered = {}
        self.cached_inconsistent = {}

        # if self.settings.recursion_enabled:
        #     query_once(f'assert(timeout({self.settings.eval_timeout})), fail')

    def janus_clear_cache(self):
        return query_once('retractall(janus:py_call_cache(_String,_Input,_TV,_M,_Goal,_Dict,_Truth,_OutVars))')

    def test_prog(self, prog):
        consult('prog', prog)
        res = query_once(f'pos_covered(S1), neg_covered(S2)')
        pos_covered = res['S1']
        neg_covered = res['S2']

        # not bothering to retract
        # x = query_once(f"retractall(prog))")
        return pos_covered, neg_covered