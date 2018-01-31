import QtQuick 2.0
import io.thp.pyotherside 1.4


// @disable-check M300
Python {
    id: py

    property int nDevices
    property bool hasDevice
    property string name
    property string version
    property string serial
    property var connections: []
    property var capabilities: []
    property var enabled: []
    property bool yubikeyReady: false
    property bool loggingReady: false
    readonly property bool ready: yubikeyReady && loggingReady
    property var queue: []

    signal enableLogging(string log_level)

    Component.onCompleted: {
        importModule('ykman.logging_setup', function () {
            loggingReady = true
        })

        importModule('site', function () {
            call('site.addsitedir', [appDir + '/pymodules'], function () {
                addImportPath(urlPrefix + '/py')
                importModule('yubikey', function () {
                    yubikeyReady = true
                })
            })
        })
    }

    onEnableLogging: {
        do_call('ykman.logging_setup.setup', [log_level || 'DEBUG'])
    }

    onReadyChanged: {
        if (ready) {
            runQueue()
        }
    }

    function runQueue() {
        var oldQueue = queue
        queue = []
        for (var i in oldQueue) {
            do_call(oldQueue[i][0], oldQueue[i][1], oldQueue[i][2])
        }
    }

    function do_call(func, args, cb) {
        if (!ready) {
            queue.push([func, args, cb])
        } else {
            call(func, args, function (json) {
                if (cb) {
                    cb(json ? JSON.parse(json) : undefined)
                }
            })
        }
    }

    function refresh() {
        do_call('yubikey.controller.count_devices', [], function (n) {
            nDevices = n
            if (nDevices == 1) {
                do_call('yubikey.controller.refresh', [], function (dev) {
                    hasDevice = dev !== undefined && dev !== null
                    name = dev ? dev.name : ''
                    version = dev ? dev.version : ''
                    serial = dev ? dev.serial : ''
                    capabilities = dev ? dev.capabilities : []
                    enabled = dev ? dev.enabled : []
                    connections = dev ? dev.connections : []
                })
            } else if (hasDevice) {
                hasDevice = false
            }
        })
    }

    function set_mode(connections, cb) {
        do_call('yubikey.controller.set_mode', [connections], cb)
    }

    function slots_status(cb) {
        do_call('yubikey.controller.slots_status', [], cb)
    }

    function erase_slot(slot, cb) {
        do_call('yubikey.controller.erase_slot', [slot], cb)
    }

    function swap_slots(cb) {
        do_call('yubikey.controller.swap_slots', [], cb)
    }

    function serial_modhex(cb) {
        do_call('yubikey.controller.serial_modhex', [], cb)
    }

    function random_uid(cb) {
        do_call('yubikey.controller.random_uid', [], cb)
    }

    function random_key(bytes, cb) {
        do_call('yubikey.controller.random_key', [bytes], cb)
    }

    function generate_static_pw(cb) {
        do_call('yubikey.controller.generate_static_pw', [], cb)
    }

    function program_otp(slot, public_id, private_id, key, cb) {
        do_call('yubikey.controller.program_otp',
                [slot, public_id, private_id, key], cb)
    }

    function program_challenge_response(slot, key, touch, cb) {
        do_call('yubikey.controller.program_challenge_response',
                [slot, key, touch], cb)
    }

    function program_static_password(slot, password, cb) {
        do_call('yubikey.controller.program_static_password',
                [slot, password], cb)
    }

    function program_oath_hotp(slot, key, digits, cb) {
        do_call('yubikey.controller.program_oath_hotp', [slot, key, digits], cb)
    }

    function openpgp_reset(cb) {
        do_call('yubikey.controller.openpgp_reset', [], cb)
    }

    function openpgp_get_touch(cb) {
        do_call('yubikey.controller.openpgp_get_touch', [], cb)
    }

    function openpgp_set_touch(adminPin, authKeyPolicy, encKeyPolicy, sigKeyPolicy, cb) {
        do_call('yubikey.controller.openpgp_set_touch', [adminPin, authKeyPolicy, encKeyPolicy, sigKeyPolicy ], cb)
    }

    function openpgp_set_pin_retries(adminPin, pinRetries, resetCodeRetries, adminPinRetries, cb) {
        do_call('yubikey.controller.openpgp_set_pin_retries', [adminPin, pinRetries, resetCodeRetries, adminPinRetries], cb)
    }

    function openpgp_get_remaining_pin_retries(cb) {
        do_call('yubikey.controller.openpgp_get_remaining_pin_retries', [], cb)
    }

    function openpgp_get_version(cb) {
        do_call('yubikey.controller.openpgp_get_version', [], cb)
    }
}
